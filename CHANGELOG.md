# 0.0.10

# 0.0.9

# 0.0.8

# 0.0.7
Major refactoring to avoid using reflection when creating new instances of users actor classes.

# 0.0.6
Added comments to all public methods... I think
Reformateed example code and added lots of comments.

# 0.0.5
updated exports to make API accesible
udpate gitignore

# 0.0.4
license

# 0.0.3

# 0.0.2

# 0.0.1
Lots of work done on actors avoiding contested food sources. Still needs some work I think
Cleaned up consumable methods and increased radius
Merge branch 'master' of https://github.com/relf108/gensim
Implemented ageing. About to increase the radius around a consumeable from which it gets actors.
Got rabbits without predators but limited resources surviving 10000+ cycles. Very intresting seeing traits change.
Update README.md
Update README.md
lots of work done on breeding patterns. These rabbits love gay sex so much they're almost dying out. gotta fix that.
More refactoring + bugfix where plants were multiplying
Quick refactoring to make code more extensible
Predators implemented. This fox is better at eating rabbits than they are at breeding. Who knew?
Everything working as expected at this point. About to add predators which could be a big change
Consumables can now regrow. Actors can die. Gender implemented. Next task is to add birth callback so that giving birth can deplete a stat like health. Also refactoring to named args for readability.
Update README.md
Added statChange property on sim which lets users increment or decrement the value of a stat each cycle. Also fixed where an Actor would only breed once
Fixed bug with stats in example where two actors had the same stat object
Breeding seems to be working. Need to think about how starting stats of a child will be set. finding, moving to and eating consumables is working as expected. Priorities are being satisfied in the expected order.
Update README.md
first commit

## 1.0.0

- Initial version, created by Stagehand
