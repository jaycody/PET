# Code Review: PET (Proprioception Enhancement Tools)

**Reviewed:** February 2026
**Original Code:** January 2012
**Author:** jaycody

---

## Project Summary

PET is a mixed-reality visual feedback system for teaching healthy body mechanics to massage therapy students. It combines Kinect depth sensors with virtual camera controls to provide real-time visual feedback, allowing students to observe themselves from multiple external perspectives as they practice massage techniques.

**Deployed:** Albuquerque School of Massage & Health Sciences, January 2012

---

## Architecture Overview

```
Kinects (depth sensing) → Processing sketch (3D point cloud) → Video goggles (output)
                                    ↑
                            iPad (OSC controls)
```

**Core Components:**
- `PET/PET.pde` (536 lines) — Main application: point cloud rendering, camera control
- `PET/hotspot_class.pde` (113 lines) — Hotspot class for preset camera positions
- `PET_iPad_Controls.touchosc` — iPad UI configuration

**Technologies:** Processing, SimpleOpenNI, PeasyCam, OSC/TouchOSC

---

## Overall Structure & Flow

The architecture is sound:

1. Capture depth data from Kinect → render as 3D point cloud
2. Allow camera to orbit freely via iPad sliders (OSC)
3. Allow camera to snap to preset "hotspot" positions via either:
   - Student raising hand into a 3D zone
   - Instructor tapping iPad button
4. Output to video goggles for proprioceptive feedback

The event-driven model (OSC input → state variables → camera transforms in draw loop) is appropriate for real-time interactive systems.

---

## Skill Level Assessment: Advanced Beginner (Jan 2012)

The code shows someone in the **"just learned OOP and actively applying it"** stage.

### Evidence of Active Learning

Comments read like a learning journal:
```java
//never did fully understand string syntaxxx  (hotspot_class.pde)
// ahhhhh, this is slick how he did this!     (hotspot_class.pde:47)
// wow, so simple so elegant. thanks Greg!    (hotspot_class.pde:88)
```

This is someone processing new concepts in real-time, not writing for future maintainers.

### Understood Classes, But Not Collections

A proper `Hotspot` class was created (good instinct), but then:
```java
Hotspot hotspotF;
Hotspot hotspotFR;
Hotspot hotspotMR;
// ... 8 separate variables
```

Instead of `Hotspot[] hotspots = new Hotspot[8];`. This led to copy-paste blocks — the same 6 lines repeated 8 times for hotspot handling.

### Understood State, But Not Abstraction

Correctly identified that `current`, `previous`, and `received` values are needed for smooth control:
```java
float lookLR = 0;
float pLookLR = 0;
float rcvLookLR = 0;
```

But this was done manually for 6 different controls (18 variables) instead of creating a reusable `SmoothValue` class.

### Coordinate System Struggles

This pattern appears throughout:
```java
pCam.lookAt(hotspotB.center.x, hotspotB.center.y *-1, hotspotB.center.z *-1, 400, 1500);
```

The `*-1` multipliers and the `rotateX(PI)` show empirical discovery that Kinect and Processing have different coordinate conventions. Fixed, but not fully internalized.

---

## Most Difficult Part

**The debounce toggle implementation** (explicitly noted in code):
```java
//SHOW CAMERA DEBOUNCE TOGGLE:
//Please take picture of these few lines of code (3 hours easy);
//4 variables needed to debounce a pushbutton used to toggle...
```

Three hours on a toggle debounce. The solution works but is more complex than necessary:
```java
if (swCam==1 && (swCam != pSwCam)) {
    if (wasOn) {
        isOn = false;
        wasOn = isOn;
    }
    else if (wasOn == false) {
        isOn = true;
        wasOn = isOn;
    }
}
```

What was actually needed: `isOn = !isOn;` inside the edge-detection condition. The `wasOn` variable is redundant.

Three different debounce patterns were implemented, each slightly different — showing active experimentation with the concept.

---

## Novice-Level Patterns Identified

| Pattern | Location | Improvement |
|---------|----------|-------------|
| Copy-paste blocks | 8 identical hotspot handlers | Loop over an array |
| Manual state triplication | `lookLR`, `pLookLR`, `rcvLookLR` × 6 | Create a `DeltaValue` class |
| Magic numbers | `400, 1500` in every `lookAt()` call | Constants or Hotspot properties |
| Debug prints in production | Multiple locations | Remove or use conditional logging |
| Empirical coordinate fixes | `*-1` scattered throughout | Understand and fix at source |
| Long if-else chains | OSC handler | Map/dictionary dispatch |
| Variables declared far from use | 45 global variables | Smaller scope or encapsulation |

---

## Strengths

1. **Proper class design for Hotspot** — Good encapsulation. The `check()`, `draw()`, `isHit()`, `clear()` lifecycle is well-conceived.

2. **Edge detection concept** — Correctly understood that `current != previous` detects transitions. Not obvious to beginners.

3. **Organized thinking** — TODO list in header shows project management instincts. Clear v1.0 vs v2.0 distinction.

4. **Extracted functions** — `calcLookLR()`, `calcLookUD()`, etc. show understanding of code organization.

5. **Attribution** — Proper credits to Borenstein and Shiffman. Good community practice.

---

## Style Summary

The code reflects someone learning by immersion: verbose, exploratory, full of self-talk and notes. It works — and that's what mattered when shipping to a massage school in Albuquerque.

**Estimated experience level:** 6-12 months of Processing/Java, likely from a non-CS background (art/design/ITP), learning primarily from Shiffman and Borenstein tutorials.

---

## Conclusion

This is a successful project. The code achieved its goal: a working installation that helped massage students learn body mechanics through real-time visual feedback. The novice patterns are normal for someone at this stage of learning, and the persistence shown (3 hours on debouncing!) is more valuable than writing perfect code on the first try.
