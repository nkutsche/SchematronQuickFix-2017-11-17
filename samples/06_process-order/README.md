| [Back](../05_microtypo/README.md) | [Up](../README.md) |  |

# Process Order of The Activity Elements

The SQF implementation of the native Oxygen acts sometimes unexpectedly. This happens if a QuickFix contains multiple Acitivity Elements and those matches on nodes whos positions are dependent on each other. In this cases the order of Activity Elements can have an unwanted affect on the QuickFix result.

The sample shows by two QuickFixes the differences. 

Background is, that the SQF implementation of the Oxygen is based on [XQuery Update](https://www.w3.org/TR/xquery-update-10/) which is not able to do two different actions at once. So the two different Activity Elements will be executed one afther the other. This means that the output of one Activity Element action is the input of the next one. If one Activity Element changes some structure, this can have an effect on the behavior of the following Activity Element.

This example should demonstrate that you don't have such problems with the Escali Oxygen Plugin. The Escali Plugin is not based on XQuery Update so it has no problem with parallel processing of multiple Activity Elements.
