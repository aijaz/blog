---
title: "Running External Commands in LLDB via Python"
date: 2017-01-11 08:00
category:
- Computers
tags:
- LLDB
- Python
- JQ
- iOS
- JSON
---

Many iOS apps today are clients of some sort. They request data from a remote server. Typically this data is served over HTTP (with SSL) and formatted as [JSON][json]. At [FastModel Sports][fm] our iOS app is constantly requesting large amounts of JSON data. While debugging the app I inevitably have to compare what I'm displaying in my views to what the server sent me. 

This meant saving the server response into an NSString, printing it out to the console with NSLog, copying that output, switching to Terminal, pasting that output into a file and then running [`jq`][jq] on that file. That's a lot of steps. In this post I'll show you how to do all of that directly from the LLD command prompt. 

<!-- more -->

[LLDB][lldb] is the default debugger in XCode. In addition to many other features, it has access to the Clang expression parser. It also has an embedded [Python][lldbPython] interpreter and makes its entire [API][pythonAPI] available as Python functions. One of the consequences of this is that we can write arbitrarily complicated Python functions and invoke them from the LLDB command prompt. The LLDB [repository][repo] has a list of sample Python scripts. A good place to start is the [template][template] file. I made a copy of this file, called it `jq.py` and modified it as shown below. The current version of this file can be found on [GitHub][jqpy].

We start off by importing required modules and creating a parser to parse command line arguments:

```python
#!/usr/bin/python

#----------------------------------------------------------------------
# Be sure to add the python path that points to the LLDB shared library.
#
# # To use this in the embedded python interpreter using "lldb" just
# import it with the full path using the "command script import"
# command
#   (lldb) command script import /path/to/file.py
#
# Inspired by 
# http://llvm.org/svn/llvm-project/lldb/trunk/examples/python/cmdtemplate.py
# 
# For a blog post describing this, visit 
# http://aijazansari.com/2017/01/11/lldb-python/
#----------------------------------------------------------------------

import lldb
import commands
import optparse
import shlex

def create_jq_options():
    """Parse the options passed to the command. 
    Also provides the description string that's used as
    the command's help string.
    """
    usage = "usage: %prog [options] <jq_filter> <variable_name>"
    description = '''This command will run the jq using jq_filter on the
NSString local variable variable_name, which is expected to contain valid JSON. 
As a side effect, the JSON contained in variable_name will be saved in
/tmp/jq_json and the filter will be saved in /tmp/jq_prog.

Example:
%prog '.[]|{firstName, lastName}' jsonStr
%prog '.[]|select(.id=="f9a5282e-523f-4b83-a6ca-566e3746a4c7").schools[1].\
school.mainLocation.address.city' body
'''
    parser = optparse.OptionParser(
        description=description,
        prog='jq',
        usage=usage)
    parser.add_option(
        '-c',
        '--compact',
        action='store_true',
        dest='compact',
        help='compact instead of pretty-printed output',
        default=False)
    parser.add_option(
        '-S',
        '--sort',
        action='store_true',
        dest='sort',
        help='sort keys of objects on output',
        default=False)
    return parser
```

Next we define the Python function that will be bound to the lldb command: 

```python
# The actual python function that is bound to the lldb command.
def jq_command(debugger, command, result, dict):

    # path to the jq executable. This is the only variable you need to change
    jq_exe = "/Users/aijaz/local/bin/jq"

    # the filter will be written to this file and will be invoked via jq -f
    # The benefit of saving the filter in a file is that we don't have to
    # worry about escaping special characters.
    jq_prog_file = "/tmp/jq_prog"

    # the value of the NSString variable will be saved in this file
    # jq will be invoked on the file, not using stdin
    # For some reason, large amounts of data were causing the lldb
    # rpc server to crash when using stdin
    jq_json_file = "/tmp/jq_json"

    # Use the Shell Lexer to properly parse up command options just like a
    # shell would
    command_args = shlex.split(command)
    parser = create_jq_options()
    try:
        (options, args) = parser.parse_args(command_args)
    except:
        # if you don't handle exceptions, passing an incorrect argument to the 
        # OptionParser will cause LLDB to exit (courtesy of OptParse dealing 
        # with argument errors by throwing SystemExit)
        result.SetError("option parsing failed")
        return

    # in a command - the lldb.* convenience variables are not to be used
    # and their values (if any) are undefined
    # this is the best practice to access those objects from within a command
    target = debugger.GetSelectedTarget()
    process = target.GetProcess()
    thread = process.GetSelectedThread()
    frame = thread.GetSelectedFrame()
    if not frame.IsValid():
        return "no frame here"

    # The command is called like "jq '.' val"
    # . is the jq program
    # val is the name of the variable
    # val_string is the value of the variable
    jq_prog = args[0]
    val = frame.var(args[1])
    val_string = val.GetObjectDescription()

    # write the json file and jq program to temp files
    f = open(jq_json_file, 'w')
    f.write(val_string)
    f.close()
    f = open(jq_prog_file, 'w')
    f.write(jq_prog)
    f.close()

    # default values of the option placeholders
    compact = ""
    sort = ""

    if options.compact :
        compact = "-c"

    if options.sort :
        sort = "-S"

    # invoke jq and print the output to the result variable
    print >>result, (commands.getoutput("%s %s %s -f %s %s" % (
        jq_exe, compact, sort, jq_prog_file, jq_json_file) ))

    # not returning anything is akin to returning success

```

Finally, we instruct the debugger to bind that Python function to a new LLDB command called `jq`: 

```python
def __lldb_init_module(debugger, dict):
    # This initializer is being run from LLDB in the embedded command interpreter
    # Make the options so we can generate the help text for the new LLDB
    # command line command prior to registering it with LLDB below
    parser = create_jq_options()
    jq_command.__doc__ = parser.format_help()

    # Add any commands contained in this module to LLDB
    debugger.HandleCommand('command script add -f jq.jq_command jq')

    print """The "jq" command has been installed, \
type "help jq" or "jq --help" for detailed help.\
"""
```

The last bit that's required is instructing LLDB to import this Python file every time the debugger starts up. The easiest way to do this is to add a line in `~/.lldbinit`: 

```
command script import /path/to/jq.py
```

Now, once LLDB starts, it will read the `.lldbinit` file, and import the Python script we wrote. As it's being imported, the script will instruct LLDB to bind the `jq` LLDB command to the `jq_command` function in the file named `jq.py` (that's the `jq.jq_command` bit). 

Then, in our iOS app, all we have to do is get our HTTP response into an NSString. One of the ways to do this is to create a JSONResponseSerializer (using AFNetworking): 

```objc
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {

    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
    NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //...
    }
```

Any time after `body` is initialized, we can break into LLDB and invoke `jq` on it:

```
(lldb) jq '.[0]|keys' body
[
  "id",
  "firstName",
  "lastName",
  "url"
]
```

As Apple's engineers pointed out at this year's WWDC, another way to import the Python file, on a per-project basis, is to insert a breakpoint in `main`. Then to that breakpoint add an action that imports the Python file.

<!-- ai c /images/2017/main.png /images/2017/main.png 582 460 Importing a Python file from a breakpoint in main -->

## Links

- [JSON][json]
- [jq][jq]
- [LLDB][lldb]
- [Python in LLDB][lldbPython]
- [LLDB Python API][pythonAPI]
- [Sample Python Scripts][repo]
- [Template file][template]
- [`jq.py`][jqpy]
- [FastModel Sports][fm]


[jq]: http://aijazansari.com/2016/10/25/jq/index.html
[lldb]: http://lldb.llvm.org/index.html
[lldbPython]: http://lldb.llvm.org/python-reference.html
[pythonAPI]: http://lldb.llvm.org/python_reference/index.html
[template]: http://llvm.org/svn/llvm-project/lldb/trunk/examples/python/cmdtemplate.py
[repo]: http://llvm.org/svn/llvm-project/lldb/trunk/examples/python/
[fm]: http://fastmodelsports.com
[json]: http://www.json.org/
[jqpy]: https://github.com/aijaz/lldbPythonScripts/blob/master/jq.py