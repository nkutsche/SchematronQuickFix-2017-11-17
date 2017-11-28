<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:es="http://www.escali.schematron-quickfix.com/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <sch:ns uri="http://www.escali.schematron-quickfix.com/" prefix="es"/>
    
    
    <sch:pattern id="multi-fix">
        <sch:title>Simple Beispiele</sch:title>
        
        <sch:rule context="medikament[@id]">
            <sch:let name="reqId" value="lower-case(replace(name, '\s|&#xA0;', ''))"/>
            <sch:assert test="@id = $reqId" sqf:fix="replaceId">Die ID muss dem Namen entsprechen, nur in Kleinbuchstaben und ohne leerzeichen.</sch:assert>
            
            <sqf:fix id="replaceId">
                <sqf:description>
                    <sqf:title>Ersetze die ID durch "<sch:value-of select="$reqId"/>"</sqf:title>
                </sqf:description>
                <sqf:replace match="@id" target="id" node-type="attribute" select="$reqId"/>
            </sqf:fix>
        </sch:rule>
        
        <sch:rule context="medikament/name">
            <sch:report test="matches(., '\s')" sqf:fix="replaceWS">Whitespace in Produktnamen sollten geschützt sein (&amp;#xA0;)!</sch:report>
            <sqf:fix id="replaceWS">
                <sqf:description>
                    <sqf:title>Ersetze alle Whitespaces mit geschützten Leerzeichen</sqf:title>
                </sqf:description>
                <sqf:stringReplace match="text()" regex="\s" select="'&#xA0;'"/>
            </sqf:fix>
        </sch:rule>
        
        <sch:rule context="patent/erstellt | patent/gueltig-bis">
            <sch:assert test=". castable as xs:date" sqf:fix="de-format set-new-date" sqf:default-fix="de-format">Muss ein gültiges Datum vom Typ xs:date sein.</sch:assert>
            <sch:let name="de-format" value="es:date-conversion-de(.)"/>
            
            <sqf:fix id="de-format" use-when="$de-format castable as xs:date">
                <sqf:description>
                    <sqf:title>Wandelt um in <sch:value-of select="$de-format"/>.</sqf:title>
                </sqf:description>
                <sqf:replace match="text()" select="$de-format"/>
            </sqf:fix>
            
            <sqf:fix id="set-new-date">
                <sqf:description>
                    <sqf:title>Setz das Datum neu.</sqf:title>
                    <sqf:p>Mit einem UserEntry</sqf:p>
                </sqf:description>
                
                <sqf:user-entry name="new-date" type="xs:date" default="current-date()">
                    <sqf:description>
                        <sqf:title>Gib ein neues Datum an.</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:replace match="text()" select="$new-date"/>
                <sqf:add match="." select="$new-date" use-when="not(text())"/>
            </sqf:fix>
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
