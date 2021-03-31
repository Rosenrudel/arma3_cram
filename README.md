# arma3_cram

This script sofar requires: **ARMA3, CBA**
https://github.com/CBATeam/CBA_A3/releases

Sources: FSG from the BI Forums circa 2017, inspiration by Yax's ITC Land Systems, people from BI Forums and others

A script that is trying to bring anti artillery, (mortar), rocket and missle capabilities to the Vanilla Preatorian

To make this function you need to add to the local description.ext the following code:

```c
class CfgFunctions {
    #include "arma3_cram\CfgFunctions.hpp"
};
```

**Roadmap:**

```
- Proper sound function to play alarm when incoming munitions are detected.
- Support multiple automated pools of CRAM units in different geographical locations.
- Make this into a mod with a duplicate of each factions CIWS unit.
- Tracer go red and have a HE time fuze connected to the target lead and speed.
```