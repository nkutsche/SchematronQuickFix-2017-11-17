<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:es="http://www.escali.schematron-quickfix.com/">
    
    <sch:ns uri="http://www.escali.schematron-quickfix.com/" prefix="es"/>
    
    <sch:phase id="oxygenOnly">
        <sch:active pattern="multi-fix"/>
        <sch:active pattern="order"/>
        <sch:active pattern="types"/>
        <sch:active pattern="regexOxygen"/>
        <sch:active pattern="copyOfOxygen"/>
    </sch:phase>
    
    
    <sch:phase id="escaliOnly">
        <sch:active pattern="multi-fix"/>
        <sch:active pattern="order"/>
        <sch:active pattern="types"/>
        <sch:active pattern="regexEscali"/>
        <sch:active pattern="copyOfEscali"/>
    </sch:phase>

    
    <sch:pattern id="multi-fix">
        <sch:title>Simple Example</sch:title>
        
        <sch:rule context="medication[@id]">
            <sch:let name="reqId" value="lower-case(replace(name, '\s|&#xA0;', ''))"/>
            <sch:assert test="@id = $reqId">The ID must match the name, only in small letters and without spaces.</sch:assert>
            
        </sch:rule>
        
        <sch:rule context="medication/name">
            <sch:report test="matches(., '\s')">Whitespaces in product names should be non-breakable (&amp;#xA0;)!</sch:report>

        </sch:rule>
        
    </sch:pattern>
    

    <sch:pattern id="types">

        <sch:title>Data Types</sch:title>

        <sch:let name="units" value="('ml', 'mg', 'g', 'cl', 'tbl')"/>

        <sch:rule context="content/amount">
            <sch:assert test=". castable as xs:double">The amount should be a number!</sch:assert>
            
        </sch:rule>

        <sch:rule context="content/unit">
            <sch:assert test="normalize-space(.) = $units">This is not a known unit. Known units are: <sch:value-of select="string-join($units, ', ')"/></sch:assert>
            
        </sch:rule>

        <sch:rule context="patent/created | patent/valid-to">
            <sch:assert test=". castable as xs:date">Shoud be a valid xs:date format.</sch:assert>
            
            
            
        </sch:rule>

    </sch:pattern>

    <sch:pattern id="copyOfEscali">
        <sch:title>sqf:copy-of</sch:title>
        
        <sch:rule context="side-effects/side-effect[@level = 'life-threatening']">
            <sch:report test="preceding-sibling::side-effect[not(@level = 'life-threatening')]">Life-threatening side effects should always take place before all other side effects.</sch:report>
            
        </sch:rule>
        
    </sch:pattern>
    
    
    <sch:pattern id="copyOfOxygen">
        <sch:title>sqf:copy-of with Oxygen</sch:title>
        
        <sch:rule context="side-effects/side-effect[@level = 'life-threatening']">
            <sch:report test="preceding-sibling::nebenwirkung[not(@level = 'life-threatening')]">Life-threatening side effects should always take place before all other side effects.</sch:report>
            
        </sch:rule>
        
    </sch:pattern>

    <sch:pattern id="regexOxygen">
        <sch:title>Regex with Oxygen</sch:title>
        <sch:rule context="application/p">
            <sch:report test="matches(., '\d+\s(ml|Jahren)')">Between the number and the unit should be always a non-breaking space (&amp;xA0;)!</sch:report>
            
        </sch:rule>
    </sch:pattern>

    <sch:pattern id="regexEscali">
        <sch:title>Regex with Escali</sch:title>
        <sch:rule context="application/p/text()" es:regex="(\d+)\s(ml|Jahren)">
            <sch:let name="d" value="regex-group(1)"/>
            <sch:report test="true()">Between the number and the unit should be always a non-breaking space (&amp;xA0;)!</sch:report>
            
        </sch:rule>
    </sch:pattern>

    <sch:pattern id="order">
        <sch:title>Order Bug</sch:title>
        <sch:rule context="application/p">
            <sch:assert test="normalize-space(.) != ''">Empty paragraphs should not be used to create space</sch:assert>
            
        </sch:rule>
    </sch:pattern>

    <xsl:function name="es:date-conversion-de">
        <xsl:param name="dd.mm.yyyy"/>
        <xsl:analyze-string select="$dd.mm.yyyy" regex="(\d\d)\.(\d\d)\.(\d\d\d\d)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(3), regex-group(2), regex-group(1)" separator="-"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring/>
        </xsl:analyze-string>
    </xsl:function>

</sch:schema>
