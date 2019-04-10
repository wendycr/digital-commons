<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <!-- This transformation is for etds -->
    
    <!-- Documentation: http://www.crossref.org/help/schema_doc/4.4.0/4.4.0.html -->
    <!-- elements of this came from https://github.com/icecjan/bepress-crossref-doi/blob/master/DC_CrossRef.xsl -->
    
    <!-- This transforms bepress metadata output in this style (add set to end of URL): 
        http://ir.uiowa.edu/do/oai/?verb=ListRecords&metadataPrefix=document-export&set=publication:etd&from=yyyy-mm-dd -->
    <!-- May need to pull more with resumption tokens http://ir.uiowa.edu/do/oai/?verb=ListRecords&resumptionToken= -->

    <!-- remove everything in initial OAI-PMH field other than OAI-PMH-->

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    
    <!-- If you use option 2 for DOIs you will need to set this variable -->
    <!-- <xsl:variable name="lookupDoc" select="document('etd-doi-match.xml')"/> -->
    
    <xsl:variable name="seriesname">
        <xsl:value-of select="substring-after(OAI-PMH/request/@set, 'publication:')"/>
    </xsl:variable>
    
    <!--<xsl:key name="details-lookup" match="root/row" use="URL" />-->
    
    <xsl:template match="/">
        <doi_batch version="4.4.0" xmlns="http://www.crossref.org/schema/4.4.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.crossref.org/schema/4.4.0 http://www.crossref.org/schemas/crossref4.4.0.xsd">
            
            <head>

                <doi_batch_id>
                    <xsl:value-of select="concat($seriesname, '-', current-dateTime())"/>
                </doi_batch_id>
                
                <xsl:variable name="date" select="adjust-date-to-timezone(current-date(), ())"/>
                <xsl:variable name="time" select="adjust-time-to-timezone(current-time(), ())"/>
                <xsl:variable name="tempdatetime" select="concat($date, '', $time)"/>
                <xsl:variable name="datetime" select="translate($tempdatetime, ':-.', '')"/>
                <timestamp>
                    <xsl:value-of select="$datetime"/>
                </timestamp>
                
                <depositor>
                    <!--Name of the organization registering the DOIs. The name placed in this element should match the name under which a depositing organization has registered with CrossRef.-->
                    <depositor_name>YOUR INSTITUION</depositor_name>
                    <email_address>YOUR EMAIL</email_address>
                </depositor>
                
                <!--The organization that owns the information being registered.-->
                <registrant>YOUR INSTITUTION</registrant>
            </head>
            
            <body>
                
                <!-- Embargoed theses are not submitted with any differences. This may not be correct. DataCite uses date available for the end of the embargo but CrossRef doesn't seem to have this -->
                 
                <xsl:for-each select="OAI-PMH/ListRecords/record">
                    <xsl:sort select="metadata/document-export/documents/document/label"/> 
                    
                    <!-- This limits DOI creation to records that have full text. If you don't have metadata only items this is not needed -->
                    <xsl:if test="metadata/document-export/documents/document/fulltext-url !=''">
                        
                        <xsl:variable name="lang">
                            <xsl:value-of
                                select="substring(normalize-space(metadata/document-export/documents/document/fields/field[@name='language']/value),1,2)"
                            />
                        </xsl:variable>  
                        
                        <dissertation publication_type="full_text" language="{$lang}" metadata_distribution_opts="any" reference_distribution_opts="none">
                            
                            <xsl:for-each
                                select="metadata/document-export/documents/document/authors/author">
                                <person_name sequence="first" contributor_role="author">
                                    <given_name>
                                        <xsl:choose>
                                            <xsl:when test="mname != ''">
                                                <xsl:value-of select="concat(fname, ' ', mname)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="fname"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </given_name>
                                    <surname>
                                        <xsl:value-of select="lname"/>
                                    </surname>
                                    <xsl:choose>
                                        <xsl:when test="suffix != ''">
                                            <affiliation>
                                                <xsl:value-of select="normalize-space(suffix)"/>
                                            </affiliation>
                                        </xsl:when>
                                        <xsl:otherwise/>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="institution != ''">
                                            <affiliation>
                                                <xsl:value-of select="normalize-space(institution)"/>
                                            </affiliation>
                                        </xsl:when>
                                        <xsl:otherwise/>
                                    </xsl:choose>
                                </person_name>  
                            </xsl:for-each>                               
    
                            <xsl:variable name="atitle">
                                <xsl:value-of
                                    select="normalize-space(metadata/document-export/documents/document/title)"
                                />
                            </xsl:variable>                 
                            <titles>
                                <xsl:choose>
                                    <xsl:when test="contains($atitle, ': ')">
                                        <title><xsl:value-of select="substring-before($atitle,': ')"/></title>
                                        <subtitle><xsl:value-of select="substring-after($atitle,': ')"/></subtitle>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <title><xsl:value-of select="$atitle"/></title>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </titles> 
                    
                            <!-- This relies on a note indicating itms have been digitized to distinguish between print opriginal and online original -->
                            <xsl:variable name="pubdate">
                                <xsl:value-of
                                    select="metadata/document-export/documents/document/publication-date"
                                />
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="contains(metadata/document-export/documents/document/fields/field[@name='notes'], 'Digitized')">
                                    <approval_date media_type="print">
                                        <month>
                                            <xsl:value-of select="substring($pubdate, 6, 2)"/>
                                        </month>
                                        <year>
                                            <xsl:value-of select="substring($pubdate, 1, 4)"/>
                                        </year>
                                    </approval_date>
                                </xsl:when>
                                <xsl:when test="contains(metadata/document-export/documents/document/fields/field[@name='notes'], 'digitized')">
                                    <approval_date media_type="print">
                                        <month>
                                            <xsl:value-of select="substring($pubdate, 6, 2)"/>
                                        </month>
                                        <year>
                                            <xsl:value-of select="substring($pubdate, 1, 4)"/>
                                        </year>
                                    </approval_date>
                                </xsl:when>
                                <xsl:otherwise>
                                    <approval_date media_type="online">
                                        <month>
                                            <xsl:value-of select="substring($pubdate, 6, 2)"/>
                                        </month>
                                        <!--<day>
                                            <xsl:value-of select="substring($pubdate, 9, 2)"/>
                                        </day>-->
                                        <year>
                                            <xsl:value-of select="substring($pubdate, 1, 4)"/>
                                        </year>
                                    </approval_date>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                            <xsl:variable name="inst">
                                <xsl:value-of
                                    select="normalize-space(metadata/document-export/documents/document/fields/field[@name='degree_grantor']/value)"
                                />
                            </xsl:variable>
                            
                            <!-- Options given for the instution due to a name change -->
                            <institution>
                                <institution_name><xsl:value-of select="$inst"/></institution_name>
                                <xsl:choose>
                                    <xsl:when test="$inst = 'YOUR OLD INSTITUTION'">
                                        <institution_acronym>XXX</institution_acronym>
                                        <institution_acronym>XXX</institution_acronym>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <institution_acronym>XXX</institution_acronym>
                                        <institution_acronym>XXX</institution_acronym>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <institution_place>YOUR INSTITUTION'S CITY, STATE, COUNTRY</institution_place>
                                <xsl:if test="metadata/document-export/documents/document/fields/field[@name='department'] != ''">
                                    <institution_department><xsl:value-of select="normalize-space(metadata/document-export/documents/document/fields/field[@name='department']/value)"/></institution_department>
                                </xsl:if>
                            </institution>
                            
                            <degree>
                                <xsl:value-of select="normalize-space(metadata/document-export/documents/document/fields/field[@name='degree_name']/value)"/>
                            </degree>
                            
                            <!-- Crossref wants DAI numbers - we do not have them -->
                            <!--<publisher_item>
                                <!-\-<item_number item_number_type="">{0,3}</item_number>-\->
                                <identifier id_type="dai"></identifier>
                            </publisher_item>-->
                            
                            <doi_data>
                                
                                <doi>
                                    
                                    <!-- Option 1: Structure the DOI based on the articleid. Note that you will still need to add it to the Digital Commons record -->
                                    <xsl:value-of
                                        select="concat('YOUR CROSSREF PREFIX/', $seriesname, '.', metadata/document-export/documents/document/articleid)"
                                    />
                                    <xsl:variable name="id" select="metadata/document-export/documents/document/articleid"/>
                                    <xsl:choose>
                                        <xsl:when test="string-length($id) = 4">                                   
                                    <xsl:value-of
                                        select="concat('YOUR CROSSREF PREFIX/etd', concat('00',$id))"
                                    />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="concat('YOUR CROSSREF PREFIX/etd', concat('0',$id))"
                                        />
                                    </xsl:otherwise>
                                    </xsl:choose>
                                    
                                    <!-- Option 2: Use a lookup table to add the DOI - Note that you will still need to add it to the Digital Commons record -->
                                    <!--<xsl:variable name="match_term" select="metadata/document-export/documents/document/coverpage-url"/>
                                    <xsl:for-each select="$lookupDoc/root/row">
                                        <xsl:variable name="original_source_term" select="URL"/>
                                        <xsl:variable name="desired_term" select="doi"/>
                                        <xsl:if test="$match_term=$original_source_term"> 
                                            <xsl:value-of select="$desired_term"/>
                                        </xsl:if>
                                    </xsl:for-each>-->
                                    
                                    <!--Option 3: Have DOI already in the Digital Commons record-->
                                    <!--<xsl:value-of select="normalize-space(metadata/document-export/documents/document/fields/field[@name='doi']/value)"/>-->
                                </doi>
                                
                                <resource>
                                    <xsl:value-of select="normalize-space(metadata/document-export/documents/document/coverpage-url)" />
                                </resource>
                            </doi_data>
                        </dissertation>
                    </xsl:if>
                </xsl:for-each>              
                                
            </body>
        </doi_batch>
    </xsl:template>
</xsl:stylesheet>