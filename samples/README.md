# Escali Oxygen Plugin &#x2013; Sample File Suite

The sample files in this suite are all based on the Relax NG schema medications.rnc. The structure described by the schema is fictional and designed to demonstrate as most use cases as possible.

The basic issue are a structure for meta information's of medications. In the basic version each medication has information's for identification, package content, side effects and the patent, if available, as well as a description of the application.

## Prerequisites

To understand the samples you should understand Schematron and Schematron QuickFix. You can learn more about this on the following sites:

- [Schematron](https://www.data2type.de/xml-xslt-xslfo/schematron/)
- [Schematron QuickFix](http://www.schematron-quickfix.com/)


## File overview

There are seven XML instances (medications.xml) as sample files in this suite, two Schematron schema and one already mentioned Relax NG schema.

The Relax NG schema defines the basic structure of the sample files. The Schematron schema defines the additional business rules.

### Sample files

Each of the seven sample files are stored in own folder, all with the name medications.xml:

1. [00_schematron](00_schematron/README.md)
1. [01_multi-fix](01_multi-fix/README.md)
1. [02_datatype](02_datatype/README.md)
1. [03_enum](03_enum/README.md)
1. [04_copy-of](04_copy-of/README.md)
1. [05_microtypo](05_microtypo/README.md)
1. [06_process-order](06_process-order/README.md)
 
Each sample file except the first one provides error messages to show a specific feature of the Escali Oxygen Plugin. Please follow the links to read more about the feature.

### Schematron schema

The Schematron schema [medications.sch](medications.sch) defines all business rules, which should be demonstrate the features of the Escali Oxygen Plugin.

The version [medications.raw.sch](medications.raw.sch) is the same as the `medications.sch` just without QuickFixes.

#### Phases

To compare the behavior of the Escali Plugin with the native Oxygen behavior, there are two phases. The phase "escaliOnly" should be used for the Escali Plugin, the phase "oxygenOnly" should be used for the native Oxygen. 

#### Paterns

There are seven patterns in the schematron:

1. Simple Example (`multi-fix`)
2. Data Types (`types`)
3. sqf:copy-of (`copyOfEscali`)
4. sqf:copy-of with Oxygen (`copyOfOxygen`)
5. Regex with Oxygen (`regexOxygen`)
6. Regex with Escali (`regexEscali`)
7. Order Bug (`order`)

*(Title and in bracktes the id)*

The assignment of the patterns can be considered as follow:

<table>
  <tr>
    <th>Pattern title</th>
    <th>Pattern id</th>
    <th>Sample folder</th>
  </tr>
  <tr>
    <td>Simple Example</td>
    <td>multi-fix</td>
    <td>01_multi-fix</td>
  </tr>
  <tr>
    <td rowspan="2">Data Types</td>
    <td rowspan="2">types</td>
    <td>02_datatype</td>
    </tr>
  <tr>
    <td>03_enum</td>
  </tr>
  <tr>
    <td>sqf:copy-of</td>
    <td>copyOfEscali</td>
    <td rowspan="2">04_copy-of</td>
    </tr>
  <tr>
    <td>sqf:copy-of with Oxygen</td>
    <td>copyOfOxygen</td>
  </tr>
  <tr>
    <td>Regex with Oxygen</td>
    <td>regexOxygen</td>
    <td rowspan="2">05_microtypo</td>
  </tr>
  <tr>
    <td>Regex with Escali</td>
    <td>regexEscali</td>
  </tr>
  <tr>
    <td>Order Bug</td>
    <td>order</td>
    <td>06_process-order</td>
  </tr>
</table>

The folder 00_schematron was designed to give an introduction into the business rules of the sample structure.

#### Business Rules

The following rules are checked by the Schematron schema:

1. The ID of a medication should always match to the name, only in small letters and without spaces
1. The name should not contain regular whitespaces to avoid linebreaks inside of the name. Only non-breaking spaces are allowed.
1. The element amount should contains always a number \*
1. The element unit should contain the values `ml`, `mg`, `g`, `cl` or `tbl` \*
1. The element created and valid-to should always have a value which is valid the format xs:date \*
1. side-effect elements with the level `life-threatening` should always be the first side-effect elements in the side-effects container.
1. For p elements applies: if you use the units "ml" or "years" with a preceding number you should use a non-breaking space between the number and the unit
1. Empty p elements should not be used to create space.   

*The rules marked with the asterisks have equivalent implementations in the Relax NG schema. In contrast to it, the Schematron implementation provides QuickFixes to fix misspelled data types.*