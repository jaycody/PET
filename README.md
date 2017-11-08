# Proprioception Enhancement Tools (PET)

## What is PET?
PET is a mixed-reality visual feedback system used to teach healthy body mechanics to massage students.  Massage instructors use a tablet-based UI to move a virtual camera into any position around a massage table. Video googles provide students with a view of themselves from the external POV set by the instructor. In this way, students can watch themselves from any angle as they learn and practice massage techniques.

## Why?
Regardless the modality, all massage schools rely on the tried and true teaching tools: demonstration, practice, and feedback. Teachers demonstrate techniques, students practice the technique on each other, and everyone provides feedback. Feedback in massage school will almost always address one of two topics:
1. The practitioner's affect on the client. ('This is how it felt')
2. The practitioner's body mechanics ('This is what you looked like')

How does one communicate 'This is what you looked like. This is how you moved. This is how you stood.'?

In massage school, instructors provide proprioceptive insight to their students with two primary tools: mirrors and mimicry.

Feedback often heard in massage class:
'Keep an eye on yourself in the mirror during this next movement. Make sure your back leg is a straight as you think it is!'
And
'Watch me. I'm going to demonstrate TO YOU what you're doing during this movement. See, you're doing it like this.'

A common exercise is to have students take turns mimicking each other. This gives them the opportunity to experience themselves from everyone else's POV, from multiple external perspectives.

But mirrors and mimicry, though useful, convey only a sliver of the real-time proprioceptive feedback that students, athletes, or rehabilitating veterans are capable of absorbing. Enter: PET

## Tools and Gear
PET introduces the following tools to the traditional massage school
### v1.0.0
- volumetric sensors (2 Kinects)
- virtual cameras
- real-time visual feedback system with video goggles and out-of-body POV
- RGB overlay of depth cloud information
- tablet-based UI that allows instructors to position a virtual camera at any angle around a massage table.

### v2.0.0
- Kinematic visualizations that help instructors identify and respond to issues body mechanics and technique.

## SETUP:  
#### The Kinects and the Mac Mini
2 Kinects placed 20 feet apart are attached to the metal grid of a drop ceiling 10 feet off the ground.  The Kinects face a massage table positioned on the floor half way between the two Kinects.  A Mac Mini running Processing and the SimpleOpenNI Library is also mounted in the drop ceiling. From below, only the volumetric sensors are visible. With volumetric information from the sensors, the Mac runs a Processing sketch that allows a user to place a virtual camera at any location within the field of the depth sensors.
#### Video Goggles
Video from the virtual camera's perspective is then sent to a pair of video goggles worn by the student. The video gives the student the rare opportunity to self-evaluate his/her body mechanics from nearly limitless external perspectives.
#### Camera Control
There are two controls for the virtual camera, either of which can move the virtual camera into any position around a massage table. The tablet-based UI allows the teacher to freely move the camera to any position within a sphere around the massage table. Additionally, the student can at any time reach up above a certain threshold height to trigger a POV transition to that location. Students can observe themselves from a perspective directly above themselves by simply lifting their arm high enough to activate the transition. User tracking functionality provided by SimpleOpenNI keeps the camera pointed at the student regardless of where around the table the student moves.

_________________

## and a THANK YOU! goes out to:
#### Greg Borenstein
- [Making Things See: 3D Vision with Kinect, Processing, Arduino, and MakerBot][1] (2012)
  - Infinite thanks to Greg Borenstein for his detailed description of Kinect hacking (in what was just a pdf at the time)

#### All things Shiffman
- [The Nature of Code: Simulating Natural Systems with Processing][3] - Dan Shiffman (2012)
  - This book is the offspring of Reynolds and the grandaddy of everything I'll ever code that seems life-like and improvisational.
  - As with Borenstein's Making Things See, The Nature of Code was still only in pdf format at the time of the PET project. Additionally, the printed copy I brought with me to Albuquerque, New Mexico for this project was a fantastically dog-eared and feverishly annotated incomplete rough draft that I'd printed on NYU printers, stapled together by chapter and carried with me everyday until the book was released a year later.  
- [The Coding Train][2] - Yes, and for the coding train.

#### [Albuquerque School of Massage & Health Sciences][4]
- Dawn Saunders, Owner and Director, LMT #3440, RMTI#S-0244



[1]:https://www.amazon.com/Making-Things-See-Processing-MakerBot/dp/1449307078
[2]:http://thecodingtrain.com/
[3]:http://natureofcode.com/
[4]:http://www.naturallifestyle.net/profiles/Albuquerque-School-of-Massage-Therapy-Health-Sciences-2273
