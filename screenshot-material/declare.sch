<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
 <sch:pattern>
     
     <sch:rule context="title">
         <sch:report test="comment()" sqf:fix="deleteComments resolveComments">
            Title should not contain comments
         </sch:report>
         
         <sqf:fix id="deleteComments">
             <sqf:description>
                 <sqf:title>Delete the comments</sqf:title>
                 <sqf:p>Delete all comments in the current title.</sqf:p>
             </sqf:description>
             <sqf:delete match="comment()"/>
         </sqf:fix>
         
         <sqf:fix id="resolveComments">
             <sqf:description>
                 <sqf:title>Resolve the Comments to text</sqf:title>
                 <sqf:p>All comments will be transformed to text nodes.</sqf:p>
             </sqf:description>
             <sqf:replace match="comment()" select="string(.)"/>
         </sqf:fix>

     </sch:rule>
     
     
 </sch:pattern>   
</sch:schema>