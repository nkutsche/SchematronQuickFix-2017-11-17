<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:es="http://www.escali.schematron-quickfix.com/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
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
            <sch:assert test="@id = $reqId" sqf:fix="replaceId">The ID must match the name, only in small letters and without spaces.</sch:assert>
            
            <sqf:fix id="replaceId">
                <sqf:description>
                    <sqf:title>Replace the ID by "<sch:value-of select="$reqId"/>"</sqf:title>
                </sqf:description>
                <sqf:replace match="@id" target="id" node-type="attribute" select="$reqId"/>
            </sqf:fix>
        </sch:rule>
        
        <sch:rule context="medication/name">
            <sch:report test="matches(., '\s')" sqf:fix="replaceWS">Whitespaces in product names should be non-breakable (&amp;#xA0;)!</sch:report>
            <sqf:fix id="replaceWS">
                <sqf:description>
                    <sqf:title>Replac all whitespaces by non-breaking whitespaces.</sqf:title>
                </sqf:description>
                <sqf:stringReplace match="text()" regex="\s" select="'&#xA0;'"/>
            </sqf:fix>
        </sch:rule>
        
    </sch:pattern>
    

    <sch:pattern id="types">

        <sch:title>Data Types</sch:title>

        <sch:let name="units" value="('ml', 'mg', 'g', 'cl', 'tbl')"/>

        <sch:rule context="content/amount">
            <sch:assert test=". castable as xs:double" sqf:fix="amount amountUnit">The amount should be a number!</sch:assert>
            <sqf:fix id="amount">
                <sqf:description>
                    <sqf:title>Resets the amount</sqf:title>
                </sqf:description>
                <sqf:user-entry name="amountNew" type="xs:double">
                    <sqf:description>
                        <sqf:title>Enter a number for the amount.</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:replace target="amount" node-type="element" select="$amountNew"/>
            </sqf:fix>
            <sqf:fix id="amountUnit">
                <sqf:description>
                    <sqf:title>Resets the amount and the unit</sqf:title>
                </sqf:description>
                <sqf:user-entry name="amountNew" type="xs:double">
                    <sqf:description>
                        <sqf:title>Enter a number for the amount.</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:user-entry name="unitNew" type="xs:string" default="'ml'">
                    <sqf:description>
                        <sqf:title>Enter the unit</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:replace target="amount" node-type="element" select="$amountNew"/>
                <sqf:replace match="../unit" target="unit" node-type="element" select="$unitNew"/>
            </sqf:fix>
        </sch:rule>

        <sch:rule context="content/unit">
            <sch:assert test="normalize-space(.) = $units" sqf:fix="unit">This is not a known unit. Known units are: <sch:value-of select="string-join($units, ', ')"/></sch:assert>
            <sqf:fix id="unit">
                <sqf:description>
                    <sqf:title>Choose a known unit</sqf:title>
                </sqf:description>
                <sqf:user-entry name="unitNew" default="$units">
                    <sqf:description>
                        <sqf:title>Specify the desired unit.</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:replace node-type="element" target="unit" select="$unitNew"/>
            </sqf:fix>
        </sch:rule>

        <sch:rule context="patent/created | patent/valid-to">
            <sch:assert test=". castable as xs:date" sqf:fix="de-format set-new-date" sqf:default-fix="de-format">Shoud be a valid xs:date format.</sch:assert>
            <sch:let name="de-format" value="es:date-conversion-de(.)"/>
            
            <sch:let name="otherDate" value="../(created | valid-to) except ."/>
            <sch:let name="year" value="xs:dayTimeDuration('P365D')"/>
            <sch:let name="defDuration" value="$year * 20"/>
            <sch:let name="default" value="
                if ($otherDate castable as xs:date) then
                (if (self::created) then
                xs:date($otherDate) - $defDuration
                else
                xs:date($otherDate) + $defDuration)
                else
                current-date()"/>
            
            <sqf:fix id="de-format" use-when="$de-format castable as xs:date">
                <sqf:description>
                    <sqf:title>Transfers into <sch:value-of select="$de-format"/>.</sqf:title>
                </sqf:description>
                <sqf:replace match="text()" select="$de-format"/>
            </sqf:fix>
            <sqf:fix id="set-new-date">
                <sqf:description>
                    <sqf:title>Resets the date.</sqf:title>
                </sqf:description>
                
                <sqf:user-entry name="new-date" type="xs:date" default="$default">
                    <sqf:description>
                        <sqf:title>Enter a new date.</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:replace match="text()" select="$new-date"/>
                <sqf:add match="." select="$new-date" use-when="not(text())"/>
            </sqf:fix>
        </sch:rule>

    </sch:pattern>

    <sch:pattern id="regexOxygen">
        <sch:title>Regex with Oxygen</sch:title>
        <sch:rule context="application/p">
            <sch:report test="matches(., '\d+\s(ml|Jahren)')" sqf:fix="insertNBSP">Between the number and the unit should be always a non-breaking space (&amp;xA0;)!</sch:report>
            <sqf:fix id="insertNBSP">
                <sqf:description>
                    <sqf:title>Replaces the space by a non-breaking space</sqf:title>
                </sqf:description>
                <sqf:stringReplace match="text()" regex="\sml" select="'&#xA0;ml'"/>
                <sqf:stringReplace match="text()" regex="\sJahren" select="'&#xA0;Jahren'"/>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>

    <sch:pattern id="regexEscali">
        <sch:title>Regex with Escali</sch:title>
        <sch:rule context="application/p/text()" es:regex="(\d+)\s(ml|Jahren)">
            <sch:let name="d" value="regex-group(1)"/>
            <sch:report test="true()" sqf:fix="insertNBSP">Between the number and the unit should be always a non-breaking space (&amp;xA0;)!</sch:report>
            <sqf:fix id="insertNBSP">
                <sqf:description>
                    <sqf:title>Replaces the space by a non-breaking space</sqf:title>
                </sqf:description>
                <sqf:replace select="replace($es:match, '(\d+)\s(ml|Jahren)', '$1&#xA0;$2')"/>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>

    <sch:pattern id="copyOfEscali">
        <sch:title>sqf:copy-of</sch:title>

        <sch:rule context="side-effects/side-effect[@level = 'life-threatening']">
            <sch:report test="preceding-sibling::side-effect[not(@level = 'life-threatening')]" sqf:fix="move">Life-threatening side effects should always take place before all other side effects.</sch:report>
            <sqf:fix id="move">
                <sqf:description>
                    <sqf:title>Move it on the first place</sqf:title>
                </sqf:description>
                <sch:let name="current" value="."/>
                <sqf:add match=".." position="first-child">
                    <sqf:copy-of select="$current" unparsed-mode="true"/>
                </sqf:add>
                <sqf:delete/>
            </sqf:fix>
        </sch:rule>

    </sch:pattern>


    <sch:pattern id="copyOfOxygen">
        <sch:title>sqf:copy-of with Oxygen</sch:title>

        <sch:rule context="side-effects/side-effect[@level = 'life-threatening']">
            <sch:report test="preceding-sibling::nebenwirkung[not(@level = 'life-threatening')]" sqf:fix="move">Life-threatening side effects should always take place before all other side effects.</sch:report>
            <sqf:fix id="move">
                <sqf:description>
                    <sqf:title>Move it on the first place</sqf:title>
                </sqf:description>
                <sch:let name="current" value="."/>
                <sqf:add match=".." position="first-child">
                    <xsl:copy-of select="$current"/>
                </sqf:add>
                <sqf:delete/>
            </sqf:fix>
        </sch:rule>

    </sch:pattern>
    
    <sch:pattern id="order">
        <sch:title>Order Bug</sch:title>
        <sch:rule context="application/p">
            <sch:assert test="normalize-space(.) != ''" sqf:fix="add_spaceBefore add_spaceBefore_orderCorrect">Empty paragraphs should not be used to create space</sch:assert>
            
            <sqf:fix id="add_spaceBefore">
                <sqf:description>
                    <sqf:title>[WRONG] Replace the paragraph by a space-before attribute in the following paragraph.</sqf:title>
                    <sqf:p>The empty paragarph will be deleted.</sqf:p>
                    <sqf:p>The following paragraph gets an style="space-before:1em".</sqf:p>
                </sqf:description>
                <sqf:delete/>
                <sqf:add match="following-sibling::p[1]" node-type="attribute" target="style" select="'space-before:1em'"/>
            </sqf:fix>
            
            <sqf:fix id="add_spaceBefore_orderCorrect">
                <sqf:description>
                    <sqf:title>[Correct] Replace the paragraph by a space-before attribute in the following paragraph.</sqf:title>
                    <sqf:p>The following paragraph gets an style="space-before:1em".</sqf:p>
                    <sqf:p>The empty paragarph will be deleted.</sqf:p>
                </sqf:description>
                <sqf:add match="following-sibling::p[1]" node-type="attribute" target="style" select="'space-before:1em'"/>
                <sqf:delete/>
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
