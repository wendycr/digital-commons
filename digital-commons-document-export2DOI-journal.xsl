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
    
    <!-- This transformation is for journals -->

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
                    <depositor_name>YOUR NAME</depositor_name>
                    <email_address>YOUR EMAIL</email_address>
                </depositor>
                
                <registrant>YOUR INSTITUTION</registrant>
            </head>
            
            <body>
                <!-- if submitting multiple years of the same journal, copy the journal section and paste another copy below for each year -->
                <journal>
                                      
                    <journal_metadata language="en">
                        
                        <!-- official name of the journal -->
                        <full_title>x</full_title>
                        
                        <!--must include, even if identical to full name --> 
                        <abbrev_title></abbrev_title>
                        
                        <!--<issn media_type="print">x</issn>-->
                        <issn media_type="electronic">x</issn>
                        
                        <!--<coden>x</coden>-->
                        
                        <!--Used to indicate the designated archiving organization(s) for an item. Values for the name attribute are 
                        CLOCKSS, LOCKSS Portico, KB, DWT (Deep Web Technologies), Internet Archive-->
                        <archive_locations>
                            <archive name="LOCKSS"/>
                        </archive_locations>
                        
                    </journal_metadata>
                    
                    <journal_issue>
                        
                        <!--optional conrtibutors-->
                        
<!--                        <titles>
                            <title>Optional issue title</title>
                        </titles>-->
                        
                        <!--publication year is required, month and day are encouraged-->    
                        <!-- date of publication - multiple dates allowed for different print / online dates -->
                        <publication_date media_type="online">                        
                            <!--<month>x</month>-->  <!-- use a leading zero if less than 10 ; see cross ref for details on season and range of months -->
                            <!--<day>x</day>--> <!-- use a leading zero if less than 10 -->
                            <year>x</year>
                        </publication_date>
                        
                        <journal_volume> 
                            <volume>x</volume>
                        </journal_volume>
                        
                        <issue>x</issue>
                                                
                    </journal_issue>             
                    
                    <xsl:for-each select="OAI-PMH/ListRecords/record">
                                             
                        <xsl:variable name="volno" select="substring-after(metadata/document-export/documents/document/submission-path,'/')" />
                        <xsl:variable name="vol" select="substring-before($volno,'/')"/>
                        <xsl:variable name="no" select="substring-before(substring-after($volno,'/'),'/')"/>
                        
                        <!--Change the details to match a specific journal issue -->   
                        <xsl:if test="$vol = 'vol1'">
                            <xsl:if test="$no ='iss1'">
                                
                                <!--if article are in multiple languages in an issue will need to adjust code to inlcude in journal_article-->
                                <journal_article publication_type="full_text">  
                                    
                                    <titles>
                                        <title><xsl:value-of select="normalize-space(metadata/document-export/documents/document/title)"/></title>
                                        <!--<subtitle>x</subtitle>--> <!--Ideally split the subtitle into its own field-->
                                    <!--<original_language_title language="">x</original_language_title>-->
                                    </titles>                                
                                    
                                    <!--Will need to deal with corporate authors and with authors having a single name-->
                                    <xsl:choose><xsl:when test="metadata/document-export/documents/document/authors/author != ''">
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
                                    </xsl:when>
                                        <xsl:otherwise/></xsl:choose>
                                    
                                    <!--<abstract></abstract>-->
                                    
                                    <!-- The date of publication online, not the publication date. The OAI does not record when a PDF was added to metadata. -->
                                    <xsl:variable name="postdate">
                                        <xsl:value-of
                                            select="metadata/document-export/documents/document/submission-date"
                                        />
                                    </xsl:variable>
                                    <xsl:variable name="pubdate">
                                        <xsl:value-of
                                            select="metadata/document-export/documents/document/publication-date"
                                        />
                                    </xsl:variable>
                                    <publication_date media_type="online">
                                        <month>
                                            <xsl:value-of select="substring($postdate, 6, 2)"/>
                                        </month>
                                        <day>
                                            <xsl:value-of select="substring($postdate, 9, 2)"/>
                                        </day>
                                        <year>
                                            <xsl:value-of select="substring($postdate, 1, 4)"/>
                                        </year>
                                    </publication_date>
                                    <publication_date media_type="print">
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
                                        <xsl:if test="metadata/document-export/documents/document/fpage!=''">
                                            <first_page>
                                                <xsl:value-of
                                                    select="metadata/document-export/documents/document/fpage"
                                                />
                                            </first_page>
                                        </xsl:if>
                                        <xsl:if test="metadata/document-export/documents/document/lpage!=''">      
                                            <last_page>
                                                <xsl:value-of
                                                    select="metadata/document-export/documents/document/lpage"
                                                />
                                            </last_page>
                                        </xsl:if>
                                    </pages>
                                    
                                    <!--If this is included for the journal, not sure if it should be included with the article-->
                                    <!--<archive_locations>
                                    <archive name="LOCKSS"/>
                                </archive_locations>-->
                                    
                                    
                                    <!-- This will structure a DOI based on the issn and the article id. Another option would be to assign a DOI when uploading and pull that into the xml (metadata/document-export/documents/document/fields/field[@name='doi']) -->
                                    <doi_data>
                                        <doi>
                                            <xsl:value-of
                                                select="concat('YOUR DOI PREFIX', metadata/document-export/documents/document/fields/field[@name='issn']/value, '.', metadata/document-export/documents/document/articleid)"
                                            />
                                        </doi>
                                        <resource>
                                            <xsl:value-of select="normalize-space(metadata/document-export/documents/document/coverpage-url)" />
                                        </resource>
                                    </doi_data>
                                </journal_article>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </journal>
                                
            </body>
        </doi_batch>
    </xsl:template>
</xsl:stylesheet>
