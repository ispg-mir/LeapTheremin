# LeapTheremin
A theremin-like instrument that is played using a Leap Motion as a controller, by Massimiliano Zanoni (Interface), Bruno Di Giorgi (Design of the instrument) and Michele Buccoli.

# Requirements
The software requires:
- a Leap Motion
- Super Collider for the instrument
- Processing for the Leap Motion interaction, with the OSC and leapmotion package.

# Instructions
Open the supercollider (.sc) and Processing (.pde) file. Windows requires to open them with Administration priviliges in order to use the network.

On SuperCollider: start a server, initialize the instrument (first block), define the address (third block) and starts the instrument (fourth block). The block does not sound unless the right hand is captured by the leap motion.

On Processing, just execute the file, and then try it with your hand on the leap motion.

# Notes
The code is provided as is. Please raise an issue if some bugs occur. The code is freely usable to develop new projects. 