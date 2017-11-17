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
        <sch:title>Simple Beispiele</sch:title>
        
        <sch:rule context="medikament[@id]">
            <sch:let name="reqId" value="lower-case(replace(name, '\s|&#xA0;', ''))"/>
            <sch:assert test="@id = $reqId">Die ID muss dem Namen entsprechen, nur in Kleinbuchstaben und ohne leerzeichen.</sch:assert>
            
        </sch:rule>
        
        <sch:rule context="medikament/name">
            <sch:report test="matches(., '\s')">Whitespace in Produktnamen sollten geschützt sein (&amp;#xA0;)!</sch:report>

        </sch:rule>
        
    </sch:pattern>
    

    <sch:pattern id="types">

        <sch:title>Datentypen</sch:title>

        <sch:let name="einheiten" value="('ml', 'mg', 'g', 'cl', 'tbl')"/>

        <sch:rule context="inhalt/menge">
            <sch:assert test=". castable as xs:double">Die Menge muss eine Zahl sein!</sch:assert>
            
        </sch:rule>

        <sch:rule context="inhalt/einheit">
            <sch:assert test="normalize-space(.) = $einheiten">Die ist keine bekannte Einheit. Bekannte Einheiten sind: <sch:value-of select="string-join($einheiten, ', ')"/></sch:assert>
            
        </sch:rule>

        <sch:rule context="patent/erstellt | patent/gueltig-bis">
            <sch:assert test=". castable as xs:date">Muss ein gültiges Datum vom Typ xs:date sein.</sch:assert>
            
            
            
        </sch:rule>

    </sch:pattern>

    <sch:pattern id="regexOxygen">
        <sch:title>Regex mit Oxygen</sch:title>
        <sch:rule context="anwendung/p">
            <sch:report test="matches(., '\d+\s(ml|Jahren)')">Zwischen der Zahl und einer Einheit immer ein Non-Breaking-Space (&amp;xA0;)!</sch:report>
            
        </sch:rule>
    </sch:pattern>

    <sch:pattern id="regexEscali">
        <sch:title>Regex mit Escali</sch:title>
        <sch:rule context="anwendung/p/text()" es:regex="(\d+)\s(ml|Jahren)">
            <sch:let name="d" value="regex-group(1)"/>
            <sch:report test="true()">Zwischen der Zahl und einer Einheit immer ein Non-Breaking-Space (&amp;#xA0;)!</sch:report>
            
        </sch:rule>
    </sch:pattern>

    <sch:pattern id="copyOfEscali">
        <sch:title>sqf:copy-of</sch:title>

        <sch:rule context="nebenwirkungen/nebenwirkung[@stufe = 'lebensbedrohlich']">
            <sch:report test="preceding-sibling::nebenwirkung[not(@stufe = 'lebensbedrohlich')]" sqf:fix="move">Lebensbedrohliche Nebenwirkungen sollten immer vor allen anderen Nebenwirkungen stehen.</sch:report>
            
        </sch:rule>

    </sch:pattern>


    <sch:pattern id="copyOfOxygen">
        <sch:title>sqf:copy-of mit Oxygen</sch:title>

        <sch:rule context="nebenwirkungen/nebenwirkung[@stufe = 'lebensbedrohlich']">
            <sch:report test="preceding-sibling::nebenwirkung[not(@stufe = 'lebensbedrohlich')]">Lebensbedrohliche Nebenwirkungen sollten immer vor allen anderen Nebenwirkungen stehen.</sch:report>
            
        </sch:rule>

    </sch:pattern>
    
    <sch:pattern id="order">
        <sch:title>Reihenfolgen-Bug</sch:title>
        <sch:rule context="anwendung/p">
            <sch:assert test="normalize-space(.) != ''">Leere Absätze dürfen nicht verwendet werden um Abstand zu erzeugen.</sch:assert>
            
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
