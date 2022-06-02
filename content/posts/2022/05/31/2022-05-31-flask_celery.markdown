title: Flask, Celery and Docker
date: 2022-05-31 08:00
Category: Computers
Tags: Web, Python, Flask, Celery, Docker

I've been working on an app that requires users to upload data to a server, where the data is used to create machine learning models. The process to create a model takes a lot of time (as much as 3 minutes). I don't want to have an HTTP request open for 3 minutes while the model is being created. I would rather the server accept the request, send back a response immediately, and queue the task for processing. Then the user can poll the server to see if their model is ready. I realized that Celery is the perfect tool for me. In this post I write about how I set up Celery and Flask and share sample code.

<!-- more -->

There are many ways for Python web servers like [Flask][flask] to run asynchronous tasks. [Celery][celery] is one of the more popular libraries for doing this. It is what's known as a Task Queue. As stated in the [Introduction to Celery][cintro], Celery needs a message transport to be able to run. A message transport provides Celery a way to communicate with the outside world - to know what tasks are pending. In my example I use the [RabbitMQ][rabbitmq] message broker to serve as Celery's message transport.

In this post I will be referring to the sample code. This code is in my [FlaskCeleryDocker repo on GitHub][gh]. There are two sample applications in this repo: the first is a standalone file that contains both, the Flask server and the Celery tasks. The second is more detailed yet simple reference app that uses Docker to have each part of the solution run in its own Docker container. There's a container for Flask, Celery, Nginx, and RabbitMQ.

## The standalone file solution

This is the simplest implementation of Flask and Celery. Almost too simple to be useful. But not quite. Let's go through it one chunk at time. The code in this blog post is current as of May 30, 2022. The most recent code, of course, can be found on [GitHub][gh].

I should mention that this solution requires your local machine to have RabbitMQ running. It also
requires you to have celery installed. You can do this by running `pip install celery`. You may 
choose to do this in a virtual environment like venv. Setting up venv is beyond the scope of this
blog post.

The file we're looking at is saved at [/flask/standalone_app.py](https://github.com/aijaz/FlaskCeleryDocker/blob/main/flask/standalone_app.py). Let's look at [line 7-17](https://github.com/aijaz/FlaskCeleryDocker/blob/main/flask/standalone_app.py#L7-L17):

#### Setup

```python
# The Flask app
app = Flask(__name__)

# The Celery app
celery = Celery(broker="amqp://localhost//")
```

Here we have _two_ applications: the Flask app, and the Celery app. The Celery app, `celery`, 
is initialized with the value of the broker that Celery should use. In this case Celery uses
the instance of RabbitMQ running on `localhost`. That's what the `amqp` scheme indicates.

#### Flask Routes

Now, let's look at [the Flask route /flask/heavy](https://github.com/aijaz/FlaskCeleryDocker/blob/main/flask/standalone_app.py#L20-L47):

```python
@app.route("/flask/heavy")
def accept_heavy_task_request():
    sleep_time = randint(1, 3)
    new_task = do_heavy_task.delay(sleep_time)
    return {"task_id": new_task.id}
```

This is the code where we accept a request to perform a time-consuming task. First, we determine
a random length of time that this task should run. Between 1 and 3 seconds. Then, we call `delay()`
on the Celery task (defined later in the file). Finally, we extract the task id from the return
value of `delay()` and return it in a JSON response.

As mentioned in the [Celery docs](https://docs.celeryq.dev/en/stable/userguide/calling.html), calling `delay()` is a shortcut for calling `apply_async()`. 
`delay()` looks more "natural" when you're starting off. But if you want to set additional
execution options, you have to use `apply_async()`. 

Normally, it would be reasonable to calculate the sleep time inside the task, and not in the 
calling function. I chose to do it here to illustrate how to pass arguments to `delay()`.

One important  thing to note is that the return value of `delay()` (`new_task`) is _not_ the return
value of the task. The task hasn't even started yet. The return value is a task object that we
can query for metadata like its `task_id`.

#### Celery Tasks

Finally, let's have a look at the [Celery task](https://github.com/aijaz/FlaskCeleryDocker/blob/main/flask/standalone_app.py#L50-L70):

```python
@celery.task(name="heavy_task", bind=True)
def do_heavy_task(self, sleep_time):
    print(f"{self.request.id}: This is a heavy task. Sleeping for {sleep_time} seconds.")
    sleep(sleep_time)
    print(f"{self.request.id}: I'm awake.")
    return f"This task took {sleep_time} seconds."
```

We indicate that this is a Celery task by using the `@celery.task` decorator. The `celery` part of
the decorator is the name of the Celery app defined earlier in the file. If we had chosen to call
it something different, we would have to use that different variable name here instead. 

There are two parameters being passed into the task decorator: `name` and `bind`. It is a good
practice to name your tasks explicitly. This ensures that the Celery worker doesn't 
run the wrong task if generates a task name in a manner that you weren't expecting. The `bind`
parameter instructs Celery that the first parameter of the task should be `self` - the task
itself. The way `self` is used on class methods. It is useful to have access to `self` if we 
want to query the task, to get its ID, for example, as we're doing here.

#### Running the standalone app

In order to get this code to run, you actually need to run 2 programs. In one terminal window, 
run the flask server by entering 

`python standalone_app.py` 

The flask server will only handle 
the routing of /flask/heavy to `accept_heavy_task_request()`. It won't run the Celery task 
(`do_heavy_task()`). That's the job of a Celery worker. 

First, make sure that RabbitMQ is running. Remember, Celery relies on RabbitMQ to determine what tasks need to run. Start a Celery worker by entering the
following in another terminal window from the same directory that contains `standalone_app.py`:

 `celery -A standalone_app.celery worker --loglevel=info`

 Then, when you visit http://localhost:8080/flask/heavy the following happens:

 1. Flask routes the request to the `accept_heavy_task_request()` function.
 2. That function calls `delay()`
 3. This means that it uses `celery` to place a request onto a RabbitMQ queue. This is a request to run the `do_heavy_task()` function.
 4. The Celery worker, which has been listening to the RabbitMQ queue finds the request. It invokes the `do_heavy_task()` function as requested by the Flask server. Everything that it prints is logged to the Celery worker's log.
 5. The Celery task (`do_heavy_task`) returns a string. However, since there is no Celery backend configured (see below), that return value is dropped on the floor; There is no process that has access to that return value. In the Docker implementation we'll see how a backend can access that return value.
 
#### standalone_app.py

Let's have a look at the entire file (without comments). Remember, this one file contains both, 
the Flask app as well as the Celery app. Flask invokes the Flask app, and Celery invokes the 
Celery app.

```python
from random import randint
from time import sleep

from flask import Flask
from celery import Celery

app = Flask(__name__)
celery = Celery(broker="amqp://localhost//")


@app.route("/flask/heavy")
def accept_heavy_task_request():
    sleep_time = randint(1, 3)
    new_task = do_heavy_task.delay(sleep_time)
    return {"task_id": new_task.id}


@celery.task(name="heavy_task", bind=True)
def do_heavy_task(self, sleep_time):
    print(f"{self.request.id}: This is a heavy task. Sleeping for {sleep_time} seconds.")
    sleep(sleep_time)
    print(f"{self.request.id}: I'm awake.")
    return f"This task took {sleep_time} seconds."


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
```

## The Docker solution

#### Introduction

With one significant exception, the code you just saw in the standalone solution is exactly 
the same code that runs in the Docker solution. The difference is in how the different 
programs are organized. Instead of running RabbitMQ, Flask, and Celery on your local computer, 
each program runs in its own Docker container. 

The exception I just spoke about is how the celery object is created. Because RabbitMQ runs
in it's own Docker container, the hostname of the RabbitMQ container is used as opposed to 
`localhost` when specifying the Celery broker. Also, this time a Celery backend is specified. 

A backend is a datastore (usually a database or a store like Redis) that is used to store the
status and return values of Celery tasks. Having a backend makes it possible to query tasks
and see if they have started, or completed, and what their results and return values are. In 
this example we use a simple SQLite3 database as a backend. 

The line that creates the Celery app (in [flask/app.py](https://github.com/aijaz/FlaskCeleryDocker/blob/main/flask/app.py#L20)) looks like this:

```python
celery = Celery(broker="amqp://my_rabbitmq_container//", 
                backend='db+sqlite:///db/backend.db')
```

The hostname of the RabbitMQ container is `my_rabbitmq_container`. We'll see how this came to be
in a minute.

#### Containers

There are four Docker containers in this system:

1. The `my_nginx_container` container hosts the main [Nginx][nginx] web page and proxy.
    1. Any request with the `/flask` URL prefix is proxied to the `my_flask_container` container.
    2. You can see this on [line 11 of /nginx/project.conf](https://github.com/aijaz/FlaskCeleryDocker/blob/a8bf85b8f7a7c28b8e1e2e0f0a036d1eac68cb9f/nginx/project.conf#L11)
2. The `my_flask_container` container hosts the [Flask][flask] app. This is done via the [gunicorn HTTP server][gunicorn].
3. The `my_rabbitmq_container` container runs [RabbitMQ][rabbitmq] which is used as Celery's broker.
4. The `my_celery_container` container runs a [Celery][celery] worker. One key point of this demo is that one can launch additional Celery containers to speed up processing of the queue.

Look at the `build.sh` scripts in the `flask`, `nginx`, and `rabbitmq` directories to see how the 
Docker images are built.

In particular, note that the build script in the `flask` directory builds two different Docker
images from the same code base. One is the Flask Docker image, and the other is the Celery Docker
image. They both share the same source code, but one invokes the Flask app, and the other invokes
the Celey app.

#### The Dockerfiles

Let's look at each of the Dockerfiles:

First, the RabbitMQ Dockerfile:

```Dockerfile
FROM rabbitmq:3
```

Then, Nginx

```Dockerfile
FROM nginx:1.15.8

# This is the Dockerfile for the nginx image. It replaces the default conf file
# with the one provided here. That one reads in the project.conf file, where our
# app-specific configurations reside.

RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/
RUN rm /etc/nginx/conf.d/default.conf
COPY project.conf /etc/nginx/conf.d/
EXPOSE 80
```

Next, we have Flask

```Dockerfile
FROM python:3.10

# This is the Dockerfile for the flask app. It's uses the same code
# base as the image for the Celery app, but invokes a different CMD.
#
# The CMD invokes gunicorn listening on port 8001 using the app object
# in app.py in the app directory (hence app.app:app).

WORKDIR /
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN mkdir app
COPY . app
CMD ["gunicorn", "-w 4", "-b 0.0.0.0:8001", "app.app:app"]
EXPOSE 8001
```

And finally, the Celery Dockerfile

```Dockerfile
FROM python:3.10

# This is the Dockerfile for the celery worker. It's uses the same
# code base as the image for the Flask app, but invokes a different
# CMD.
#
# Note that the CMD specifies app.app.celery, because in app.py the
# name of the Celery object is 'celery', not 'app'.

WORKDIR /
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN mkdir app
COPY . app
CMD ["celery", "-A", "app.app.celery", "worker", "--loglevel=info"]
```

#### The bridge network

These containers need to communicate with each other. The Nginx container needs to proxy to the 
Flask container. The Flask and the Celery containers need to use the broker running in the
RabbitMQ container. 

By default, there is no way to tell what IP address will be assigned to each container. So the 
code and config files cannot specify an IP address to refer to the flask and rabbitmq containers.

The approach this demo uses is to create a Docker bridge network named `my_network`. When the 
containers are created, they are assigned to this network, and assigned a name. Docker will then 
assign the container that name as its hostname on that bridge network. This allows us to use the 
hostname in the code and config files.

This is done in the top-level build.sh script:

```bash
#!/bin/bash

set -e

# Delete all data from the backend (start fresh)
echo "delete from celery_taskmeta; delete from celery_tasksetmeta;" | sqlite3 db/backend.db

# Build the images in each of the 3 directories below
for f in flask nginx rabbitmq;
  do
    pushd $f || exit 1
    ./build.sh
    popd || exit 1
  done

# Create a docker network named my_network if one doesn't already exist.
docker network create --driver bridge my_network || true

# Create and launch the four docker containers.
#
# TECHNICALLY we don't need the -it options here. I include them anyway because
# having them means that the output of docker logs is colorized.

docker run -d -it --name my_rabbitmq_container \
           -v "$(pwd)"/document_root:/document_root \
           -v "$(pwd)"/db:/db \
           --network my_network my_rabbitmq
docker run -d -it --name my_flask_container    \
           -v "$(pwd)"/document_root:/document_root \
           -v "$(pwd)"/db:/db \
           --network my_network my_flask
docker run -d -it --name my_celery_container   \
           -v "$(pwd)"/document_root:/document_root \
           -v "$(pwd)"/db:/db \
           --network my_network my_celery
docker run -d -it --name my_nginx_container    \
           -v "$(pwd)"/document_root:/document_root \
           -v "$(pwd)"/db:/db \
           --network my_network -p 8000:80 my_nginx
```

All these containers are assigned hostnames by Docker that are equal the names of the containers in the file above.
Knowing these names in advance allows us to use these names in our code (as shown above where the celery broker is set), as well
as in our config files. This is the relevant part of the Nginx configuration (in `project.conf`) that proxies
traffic to the flask container:

```bash
    #...
    location /flask {
        # Here the container name from /build.sh is being used as a hostname.
        # Docker makes the containter available as a hostname.
        proxy_pass http://my_flask_container:8001;
        # ...
    }
```

#### Docker bind mounts

For illustration purposes there are two bind mounts used in this sample code. The first is `/document_root`
which is the document root of the nginx server. This is used to show how nginx is used to serve
static files off the document root and also proxy more complicated requests to the Flask web
server.

The second bind mount is `/db`. This is used to host the `backend.db` sqlite3 database file. Both, 
the Flask and Celery containers need to be able to access the Celery backend. I chose to use 
sqlite3 instead of Postgres as a backend database because the former is easier to set up for the
purposes of my demo.

#### Starting the Docker solution

From the main directory run `build.sh`. This will do the following:

- Create the flask, nginx, celery and rabbitmq images
- Create the bridge network
- Launch each container, assigning it to the the bridge network and giving it a known container name.

#### Running the system

From your browser, visit http://localhost:8000/flask/heavy. This will enqueue a task that takes
between 1 and 3 seconds to complete.

You can view the Celery worker logs by running `docker logs -f my_celery_container`.

You can view the list of tasks in the RabbitMQ queue (that aren't picked up by a worker yet) by
running `list_queues.sh`.

You can have this list of tasks updated approxmiately every two seconds by running `monitor_queue.sh`. 

You can launch a [Locust][locust] swarm of load-testing requests by doing the following:

1. `cd locust`
2. `./locust --host http://localhost:8000/`
3. Visit http://localhost:8089
4. Start a load test with 2 - 3 users, and a swarm rate of 1 - 4.

**_Bear in mind that within minutes you will have queued tens of thousands of requests to be
processed by Celery. End this load test quickly._**

Once the load test is stopped, you can run `monitor_queues.sh` to view how quickly the 
queue is processed. You can speed up the processing of the queue by adding more celery workers
via `launch_celery_worker.sh`.

#### Task Status

When you visit http://localhost:8000/flask/heavy the Flask server returns a JSON object
that includes the task id. You can use this task id to query the status of the task using 
http://localhost:8000/flask/status?task_id=xxxxx where `xxxxx` is the task id returned by
`/flask/heavy`.

You can retrieve a list of all tasks by visiting http://localhost:8000/flask/tasks.

## Summary

I hope you found reading this illustration of using Flask, Celery, and Docker as beneficial as I did while
writing it. If you have any questions about anything in this post, please feel free to contact me 
on [Twitter](https://twitter.com/_aijaz_).

[celery]: https://docs.celeryq.dev/
[rabbitmq]: https://www.rabbitmq.com/
[flask]: https://flask.palletsprojects.com/en/2.1.x/
[nginx]: https://nginx.org/en/docs/
[locust]: https://locust.io/
[vid]: https://youtu.be/iwxzilyxTbQ
[gh]: https://github.com/aijaz/FlaskCeleryDocker
[cintro]: https://docs.celeryq.dev/en/stable/getting-started/introduction.html
[gunicorn]: https://gunicorn.org/
