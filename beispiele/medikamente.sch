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
        
    </sch:pattern>
    

    <sch:pattern id="types">

        <sch:title>Datentypen</sch:title>

        <sch:let name="einheiten" value="('ml', 'mg', 'g', 'cl', 'tbl')"/>

        <sch:rule context="inhalt/menge">
            <sch:assert test=". castable as xs:double" sqf:fix="menge mengeEinheit">Die Menge muss eine Zahl sein!</sch:assert>
            <sqf:fix id="menge">
                <sqf:description>
                    <sqf:title>Setze die Menge neu</sqf:title>
                </sqf:description>
                <sqf:user-entry name="mengeNeu" type="xs:double">
                    <sqf:description>
                        <sqf:title>Gib die Menge als eine Zahl ein.</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:replace target="menge" node-type="element" select="$mengeNeu"/>
            </sqf:fix>
            <sqf:fix id="mengeEinheit">
                <sqf:description>
                    <sqf:title>Setze die Menge und Einheit neu</sqf:title>
                </sqf:description>
                <sqf:user-entry name="mengeNeu" type="xs:double">
                    <sqf:description>
                        <sqf:title>Gib die Menge als eine Zahl ein.</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:user-entry name="einheitNeu" type="xs:string" default="'ml'">
                    <sqf:description>
                        <sqf:title>Gib die Einheit an.</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:replace target="menge" node-type="element" select="$mengeNeu"/>
                <sqf:replace match="../einheit" target="einheit" node-type="element" select="$einheitNeu"/>
            </sqf:fix>
        </sch:rule>

        

        <sch:rule context="patent/erstellt | patent/gueltig-bis">
            <sch:assert test=". castable as xs:date" sqf:fix="de-format set-new-date" sqf:default-fix="de-format">Muss ein gültiges Datum vom Typ xs:date sein.</sch:assert>
            <sch:let name="de-format" value="es:date-conversion-de(.)"/>
            
            <sch:let name="otherDate" value="../(erstellt | gueltig-bis) except ."/>
            <sch:let name="year" value="xs:dayTimeDuration('P365D')"/>
            <sch:let name="defDuration" value="$year * 20"/>
            <sch:let name="default" value="
                if ($otherDate castable as xs:date) then
                (if (self::erstellt) then
                xs:date($otherDate) - $defDuration
                else
                xs:date($otherDate) + $defDuration)
                else
                current-date()"/>
            
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
                
                <sqf:user-entry name="new-date" type="xs:date" default="$default">
                    <sqf:description>
                        <sqf:title>Gib ein neues Datum an.</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:replace match="text()" select="$new-date"/>
                <sqf:add match="." select="$new-date" use-when="not(text())"/>
            </sqf:fix>
        </sch:rule>
        
        <sch:rule context="inhalt/einheit">
            <sch:assert test="normalize-space(.) = $einheiten" sqf:fix="einheit">Die ist keine bekannte Einheit. Bekannte Einheiten sind: <sch:value-of select="string-join($einheiten, ', ')"/></sch:assert>
            <sqf:fix id="einheit">
                <sqf:description>
                    <sqf:title>Wähle eine bekannte einheit aus</sqf:title>
                </sqf:description>
                <sqf:user-entry name="einheitNeu" default="$einheiten">
                    <sqf:description>
                        <sqf:title>Gib die gewünschte Einheit an.</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:replace node-type="element" target="einheit" select="$einheitNeu"/>
            </sqf:fix>
        </sch:rule>

    </sch:pattern>
    
    <sch:pattern id="copyOfOxygen">
        <sch:title>sqf:copy-of mit Oxygen</sch:title>
        
        <sch:rule context="nebenwirkungen/nebenwirkung[@stufe = 'lebensbedrohlich']">
            <sch:report test="preceding-sibling::nebenwirkung[not(@stufe = 'lebensbedrohlich')]" sqf:fix="move">Lebensbedrohliche Nebenwirkungen sollten immer vor allen anderen Nebenwirkungen stehen.</sch:report>
            <sqf:fix id="move">
                <sqf:description>
                    <sqf:title>Schiebe an die erste Stelle</sqf:title>
                </sqf:description>
                <sch:let name="current" value="."/>
                <sqf:add match=".." position="first-child">
                    <xsl:copy-of select="$current"/>
                </sqf:add>
                <sqf:delete/>
            </sqf:fix>
        </sch:rule>
        
    </sch:pattern>
    
    <sch:pattern id="copyOfEscali">
        <sch:title>sqf:copy-of</sch:title>
        
        <sch:rule context="nebenwirkungen/nebenwirkung[@stufe = 'lebensbedrohlich']">
            <sch:report test="preceding-sibling::nebenwirkung[not(@stufe = 'lebensbedrohlich')]" sqf:fix="move">Lebensbedrohliche Nebenwirkungen sollten immer vor allen anderen Nebenwirkungen stehen.</sch:report>
            <sqf:fix id="move">
                <sqf:description>
                    <sqf:title>Schiebe an die erste Stelle</sqf:title>
                </sqf:description>
                <sch:let name="current" value="."/>
                <sqf:add match=".." position="first-child">
                    <sqf:copy-of select="$current" unparsed-mode="true"/>
                </sqf:add>
                <sqf:delete/>
            </sqf:fix>
        </sch:rule>
        
    </sch:pattern>
    

    <sch:pattern id="regexOxygen">
        <sch:title>Regex mit Oxygen</sch:title>
        <sch:rule context="anwendung/p">
            <sch:report test="matches(., '\d+\s(ml|Jahren)')" sqf:fix="insertNBSP">Zwischen der Zahl und einer Einheit immer ein Non-Breaking-Space (&amp;xA0;)!</sch:report>
            <sqf:fix id="insertNBSP">
                <sqf:description>
                    <sqf:title>Ersetze das Leerzeichen durch einen Non-Breaking-Space</sqf:title>
                </sqf:description>
                <sqf:stringReplace match="text()" regex="\sml" select="'&#xA0;ml'"/>
                <sqf:stringReplace match="text()" regex="\sJahren" select="'&#xA0;Jahren'"/>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>

    <sch:pattern id="regexEscali">
        <sch:title>Regex mit Escali</sch:title>
        <sch:rule context="anwendung/p/text()" es:regex="(\d+)\s(ml|Jahren)">
            <sch:report test="true()" sqf:fix="insertNBSP">Zwischen der Zahl und einer Einheit immer ein Non-Breaking-Space (&amp;#xA0;)!</sch:report>
            <sqf:fix id="insertNBSP">
                <sqf:description>
                    <sqf:title>Ersetze das Leerzeichen durch einen Non-Breaking-Space</sqf:title>
                </sqf:description>
                <sqf:replace select="replace($es:match, '(\d+)\s(ml|Jahren)', '$1&#xA0;$2')"/>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>

    
    
    <sch:pattern id="order">
        <sch:title>Reihenfolgen-Bug</sch:title>
        <sch:rule context="anwendung/p">
            <sch:assert test="normalize-space(.) != ''" sqf:fix="add_spaceBefore add_spaceBefore_orderCorrect">Leere Absätze dürfen nicht verwendet werden um Abstand zu erzeugen.</sch:assert>
            
            <sqf:fix id="add_spaceBefore">
                <sqf:description>
                    <sqf:title>[FALSCH] Ersetzt den Absatz durch ein space-before-Attribut im folgenden Absatz.</sqf:title>
                    <sqf:p>Der leere Absatz wird gelöscht.</sqf:p>
                    <sqf:p>Der folgende Absatz erhält ein style="space-before:1em".</sqf:p>
                </sqf:description>
                <sqf:delete/>
                <sqf:add match="following-sibling::p[1]" node-type="attribute" target="style" select="'space-before:1em'"/>
            </sqf:fix>
            
            <sqf:fix id="add_spaceBefore_orderCorrect">
                <sqf:description>
                    <sqf:title>[RICHTIG] Ersetzt den Absatz durch ein space-before-Attribut im folgenden Absatz.</sqf:title>
                    <sqf:p>Der leere Absatz wird gelöscht.</sqf:p>
                    <sqf:p>Der folgende Absatz erhält ein style="space-before:1em".</sqf:p>
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
