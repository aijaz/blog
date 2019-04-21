title: Code Coverage Without Pod Files
date: 2016-12-25 23:50
Category: Computers
Tags: QuranMemorizer, QMUpgrade, Programming, iOS

*Another in a series of posts documenting my process of updating an aging app.*

I noticed that the code coverage reports from XCode 8 recently started showing me coverage for `.m` files that were in the CocoaPods that I'm using. In this post I document how I fixed that.

<!-- more -->

I take no credit for this fix, other than persistent Googling. It might be obvious to you, but it cost me an hour of searching, and if this post saves you some time, it will be worth it. The solution comes from [this Stack Overflow answer][so].

Essentially, I modified my Podfile by adding a build setting to disable code coverage for every Pod. I guess I could have done this manually, by modifying the scheme for each Pod target. 

```
#   Disable Code Coverage for Pods projects
post_install do |installer_representation|
   installer_representation.pods_project.targets.each do |target|
       target.build_configurations.each do |config|
            config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
       end
   end
end
```

This is how the coverage data looked before the fix:

<!-- ai c /images/2016/coverage1.png /images/2016/coverage1.png 526 799 Coverage with Pods included -->

And this is how the data looks now, after the fix: 

<!-- ai c /images/2016/coverage2.png /images/2016/coverage2.png 542 530 Coverage without Pods' .m files -->


[so]: http://stackoverflow.com/a/40485022/7221535 
