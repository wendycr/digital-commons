<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <!-- remove xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd" from <OAI-PMH> 
        ALSO remove xmlns="http://www.openarchives.org/OAI/2.0/" -->
    
    <!-- Documentation: http://www.crossref.org/help/schema_doc/4.4.0/4.4.0.html -->
    <!-- elements of this came from https://github.com/icecjan/bepress-crossref-doi/blob/master/DC_CrossRef.xsl -->
    
    <!-- This transforms bepress metadata output in this style (add set to end of URL): 
        http://ir.uiowa.edu/do/oai/?verb=ListRecords&metadataPrefix=document-export&set=publication: -->
    <!-- May need to pull more with resumption tokens http://ir.uiowa.edu/do/oai/?verb=ListRecords&resumptionToken= -->
    <!-- May want to include dates to find recently edited items &from=yyyy-mm-dd-->
    
    <!-- This transformation is for formally published conference proceedings -->

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/">
        <doi_batch version="4.4.0" xmlns="http://www.crossref.org/schema/4.4.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.crossref.org/schema/4.4.0 http://www.crossref.org/schemas/crossref4.4.0.xsd">
            
            <head>
                <xsl:variable name="seriesname">
                    <xsl:value-of select="substring-after(OAI-PMH/request/@set, 'publication:')"/>
                </xsl:variable>
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
                    <depositor_name>ORGANIZATION REGISTERING DOIS</depositor_name>
                    <email_address>YOUR EMAIL</email_address>
                </depositor>
                
                <registrant>ORGANIZATION THAT OWNS THE INFO</registrant>
            </head>
            
            <body>
                <!-- if submitting multiple years of the same conference, copy the conference section and paste another copy below for each year -->
                <conference>
                    
                    <!--Edit for conference-->
                    <contributors>
                        <person_name contributor_role="editor" sequence="first">
                            <given_name>x</given_name>
                            <surname>x</surname>
                            <affiliation>x</affiliation>
                        </person_name>
                        <person_name contributor_role="editor" sequence="additional">
                            <given_name>x</given_name>
                            <surname>x</surname>
                            <affiliation>x</affiliation>
                        </person_name>
                    </contributors>
                    
                    <event_metadata>
                        <!-- official name of the conference - does not include "Proceedings of" -->
                        <conference_name>x</conference_name>
                        
                        <!--<conference_theme></conference_theme>-->
                        
                        <conference_acronym>x</conference_acronym>
                        
                        <!--<conference_sponsor></conference_sponsor>-->
                        
                        <!-- should match name="volnum" -->
                        <conference_number>x</conference_number>
                        
                        <!--city and country, should match name="location"-->
                        <conference_location>x</conference_location>
                        
                        <!--date of the conference -->
                        <conference_date start_year="x" start_month="x" start_day="x" end_year="x" end_month="x" end_day="x">x</conference_date>
                        
                    </event_metadata>
                    
                    <proceedings_metadata language="en">
                        
                        <!-- Full title of the proceedings volume, should match <publication-title> and the 245 if cataloged -->
                        <proceedings_title>x</proceedings_title>
                        
                        <!--<proceedings_subject></proceedings_subject>-->
                        
                        <publisher>
                            <publisher_name>x</publisher_name>
                            <publisher_place>x</publisher_place>
                        </publisher>
                        
                        <!-- Date posted online -->
                        <publication_date media_type="online">
                            <month>x</month>
                            <day>x</day>
                            <year>x</year>
                        </publication_date>
                        
                        <noisbn reason="archive_volume"/>
                        
                        <!--<publisher_item></publisher_item>-->
                        
                        <!-- <archive_locations> <archive name=""></archive> </archive_locations>-->
                        
                        <!--Optional DOI for proceedings as a whole-->
<!--                        <doi_data>
                            <!-\-don't add a year to a base conference with only a period as it will look like an article id and cause problems in the future-\->
                            <doi>x</doi>
                            <!-\-<timestamp></timestamp>-\->
                            <resource></resource>
                            <!-\-<collection></collection>-\->
                        </doi_data>-->
                        
                    </proceedings_metadata>
                    
                    <xsl:for-each select="OAI-PMH/ListRecords/record">
                        <xsl:variable name="confdate">
                            <xsl:value-of
                                select="substring(metadata/document-export/documents/document/publication-date, 1, 4)"
                            />
                        </xsl:variable>
                        
                        <!--Change the year to match specific conference or comment out the if -->
                        <xsl:if test="$confdate = '2014'">
                            <conference_paper>
                                <contributors>
                                    <xsl:for-each
                                        select="metadata/document-export/documents/document/authors/author">
                                        <xsl:if test="position() = 1">
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
                                                <!--Note the schema documentation for affiliation - do not include in the submission if multiple affliations are in one field-->
                                                <xsl:choose>
                                                  <xsl:when test="institution != ''">
                                                  <affiliation>
                                                      <xsl:value-of select="normalize-space(institution)"/>
                                                  </affiliation>
                                                  </xsl:when>
                                                  <xsl:otherwise/>
                                                </xsl:choose>
                                            </person_name>
                                        </xsl:if>
                                        <xsl:if test="position() != 1">
                                            <person_name sequence="additional"
                                                contributor_role="author">
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
                                                  <xsl:when test="institution != ''">
                                                  <affiliation>
                                                      <xsl:value-of select="normalize-space(institution)"/>
                                                  </affiliation>
                                                  </xsl:when>
                                                  <xsl:otherwise/>
                                                </xsl:choose>
                                            </person_name>
                                        </xsl:if>
                                    </xsl:for-each>
                                </contributors>
                                <titles>
                                    <title><xsl:value-of
                                        select="normalize-space(metadata/document-export/documents/document/title)"
                                        /></title>
                                </titles>
                                <xsl:variable name="confdate">
                                    <xsl:value-of
                                        select="metadata/document-export/documents/document/fields/field[@name = 'publication_date']"
                                    />
                                </xsl:variable>
                                <!-- The date of publication online, not the conference date. Publication_date may be better for some conferences. The OAI does not record when a PDF was added to metadata. -->
                                <xsl:variable name="pubdate">
                                    <xsl:value-of
                                        select="metadata/document-export/documents/document/submission-date"
                                    />
                                </xsl:variable>
                                <publication_date media_type="online">
                                    <month>
                                        <xsl:value-of select="substring($pubdate, 6, 2)"/>
                                    </month>
                                    <day>
                                        <xsl:value-of select="substring($pubdate, 9, 2)"/>
                                    </day>
                                    <year>
                                        <xsl:value-of select="substring($pubdate, 1, 4)"/>
                                    </year>
                                </publication_date>
                                <pages>
                                    <first_page>
                                        <xsl:value-of
                                            select="metadata/document-export/documents/document/fpage"
                                        />
                                    </first_page>
                                    <last_page>
                                        <xsl:value-of
                                            select="metadata/document-export/documents/document/lpage"
                                        />
                                    </last_page>
                                </pages>
                                <!-- This will structure a DOI based on the series name and the article id. Another option would be to assign a DOI when uploading and pull that into the xml (metadata/document-export/documents/document/fields/field[@name='doi']) -->
                                <xsl:variable name="series">
                                    <xsl:value-of
                                        select="substring-before(substring-after(header/identifier, 'oai:ir.uiowa.edu:'), '-')"
                                    />
                                </xsl:variable>
                                <doi_data>
                                    <doi>
                                        <xsl:value-of
                                            select="concat('YOUR DOI PREFIX', $series, '.', metadata/document-export/documents/document/articleid)"
                                        />
                                    </doi>
                                    <resource>
                                        <xsl:value-of
                                            select="normalize-space(metadata/document-export/documents/document/coverpage-url)"
                                        />
                                    </resource>
                                </doi_data>
                            </conference_paper>
                        </xsl:if>
                    </xsl:for-each>
                </conference>
                                
            </body>
        </doi_batch>
    </xsl:template>
</xsl:stylesheet>
