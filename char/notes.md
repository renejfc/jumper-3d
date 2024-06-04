# Nodes

- The TwistPivot node is 3D space point in the middle of the char that the camera can rotate around horizontally
- I can modify the Y axis on the TwistPivot if needed (not sure about all the others tho)
- The PitchPivot node is the one that should be **rotated** on any axis
- But the Camera3D is the one that "has" to be the control of the distance *(Z axis)*
although this can also be controlled in the TwistPivot idk what are the implications

# Misc
- The *Char* instance in the *Level* is "damped" to decrease velocity *(see Linear menu on node)*
