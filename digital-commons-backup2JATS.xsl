<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- see https://jats.nlm.nih.gov/publishing/tag-library/1.2d1/element/pub-date.html -->
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/"> 
        
        <xsl:for-each select="documents/document">
            
            <xsl:if test="fulltext-url !=''">
            <xsl:if test="state ='published'">
                            
        <!--Note that a non-English publication will need a change in the lang value https://jats.nlm.nih.gov/publishing/tag-library/0.4/n-frj0.html-->
        
        <!--<xsl:result-document method="xml" href="{translate(submission-path,'/','-')}.xml" >-->
                    <xsl:result-document method="xml" href="{articleid}.xml" >
            
        <article xmlns:ali="http://www.niso.org/schemas/ali/1.0/" dtd-version="1.2d1" xml:lang="en"
            xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:oasis="http://www.niso.org/standards/z39-96/ns/oasis-exchange/table">
            <front>
                <journal-meta>
                    <!--Not in our metadata - add if necessary -->
                    <!-- <journal-id journal-id-type="pmc"></journal-id> <journal-id journal-id-type="pubmed"></journal-id>-->
                    <journal-id journal-id-type="publisher">
                        <xsl:value-of select="substring-before(submission-path, '/')"/>
                    </journal-id>
                                        
                    <!-- if multiple titles in same series or subtitle, select pub_title lines -->
                    <journal-title-group>
                        <journal-title><xsl:value-of select="normalize-space(publication-title)"/></journal-title>
                        <!--<xsl:variable name="jtitle">
                            <xsl:value-of
                                select="normalize-space(fields/field[@name = 'pub_title'])"
                            />
                        </xsl:variable>
                        <journal-title><xsl:value-of select="substring-before($jtitle,': ')"/></journal-title>
                        <journal-subtitle><xsl:value-of select="substring-after($jtitle,': ')"/></journal-subtitle>-->
                        
                        <!--If the URL is not an abbreviated title, comment this out-->
                        <!--<abbrev-journal-title abbrev-type="publisher"><xsl:value-of select="upper-case(substring-before(submission-path, '/'))"/></abbrev-journal-title>-->
                    </journal-title-group>
                    
<!--                    <contrib-group>
                        <contrib></contrib>
                    </contrib-group>-->
                    
                    <!--If no print version, comment out print ISSN-->
                    <!--<issn publication-format="print"><xsl:value-of select="normalize-space(fields/field[@name = 'issn'])"/></issn>-->
                    <issn publication-format="electronic"><xsl:value-of select="substring-after(normalize-space(fields/field[@name = 'pub_issn']),'urn:ISSN:')"/></issn>
                    <issn-l><xsl:value-of select="normalize-space(fields/field[@name = 'issn'])"/></issn-l>
                    
                    <publisher>
                        <publisher-name><xsl:value-of select="normalize-space(fields/field[@name = 'publisher'])"/></publisher-name>
                        <!--Value not in our metadata -->
                        <publisher-loc>Iowa City, Iowa</publisher-loc>
                    </publisher>
                    
                    <!--<notes></notes>-->
                    
                </journal-meta>
    
                <article-meta>
                    <article-id pub-id-type="publisher"><xsl:value-of select="articleid"/></article-id>
                    <article-id pub-id-type="doi"><xsl:value-of select="normalize-space(fields/field[@name = 'doi'])"/></article-id>
                    
                    <xsl:choose> 
                        <xsl:when test="fields/field[@name = 'journal_article_version']='Version of Record'"> 
                            <article-version vocab="JAV"
                                vocab-identifier="http://www.niso.org/publications/rp/RP-8-2008.pdf"
                                article-version-type="VoR" vocab-term="Version of Record">Version of Record></article-version>
                        </xsl:when>
                        <xsl:when test="fields/field[@name = 'journal_article_version']='Corrected Version of Record'"> 
                            <article-version vocab="JAV"
                                vocab-identifier="http://www.niso.org/publications/rp/RP-8-2008.pdf"
                                article-version-type="CVoR" vocab-term="Corrected Version of Record"
                                >Corected Version of Record></article-version>
                        </xsl:when>
                    </xsl:choose>

                    <article-categories>
                        <subj-group>
                            <subject><xsl:value-of select="document-type"/></subject>
                        </subj-group>
                    </article-categories>
                    
                    <title-group>
                        <article-title><xsl:value-of select="title"/></article-title>
                    </title-group>
                    
                    <!--May need to adjust for authors with one name and corporate authors-->
                    <xsl:if test="authors/author !=''">
                    <contrib-group>
                        <xsl:for-each select="authors/author">
                        <contrib contrib-type="author">
                            <name>
                                <xsl:if test="lname != ''">
                                <surname><xsl:value-of select="lname"/></surname>
                                <given-names>
                                    <xsl:choose>
                                        <xsl:when test="mname != ''">
                                            <xsl:value-of select="concat(fname, ' ', mname)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="fname"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </given-names>
                                <!--<prefix></prefix>-->
                                    <xsl:if test="suffix != ''">
                                        <suffix><xsl:value-of select="suffix"/></suffix>
                                    </xsl:if>
                                </xsl:if>
                                <!--This section is for non-Western authors with single (one-part) names - may want to switch to surname in some cases - see also https://jats.nlm.nih.gov/publishing/tag-library/1.2d1/element/surname.html-->
                                <xsl:if test="organization != ''">
                                    <given-names><xsl:value-of select="organization"/></given-names>
                                </xsl:if>
                            </name>
                            <!--should htis simply be in aff?-->
                            <xsl:if test="institution != ''">
                            <aff>
                                <institution-wrap>
                                    <institution><xsl:value-of select="institution"/></institution>
                                </institution-wrap>
                            </aff>
                            </xsl:if>
                        </contrib>
                        </xsl:for-each>
                    </contrib-group>
                    </xsl:if>
                    
                    <!--adjust as need to use appropriate elements of date OR season-->
                    <!--adjust based on whether it is online only, if print publsihed at the same time, or if print was before online-->                 
                    <!-- may need to use <field name="publication_date" type="date"><value>2017-08-30T00:00:00-07:00</value></field> -->
                    <xsl:variable name="pubdate">
                        <xsl:value-of
                            select="substring(publication-date,1,7)"
                        />
                    </xsl:variable>
                    <pub-date date-type="pub" publication-format="print" iso-8601-date="{$pubdate}">
                        <day>
                            <xsl:value-of select="substring(publication-date, 9, 2)"/>
                        </day>                    
                        <month>
                            <xsl:value-of select="substring(publication-date, 6, 2)"/>
                        </month>
                        <!--If season is needed will need to figure this out - not actually in metadata-->
                        <!--<season></season>-->
                        <year>
                            <xsl:value-of select="substring(publication-date, 1, 4)"/>
                        </year>
                    </pub-date>
                    
                    <xsl:variable name="postdate">
                        <xsl:value-of
                            select="substring(submission-date,1,10)"
                        />
                    </xsl:variable>
                    <pub-date date-type="pub" publication-format="online" iso-8601-date="{$postdate}">
                        <day>
                            <xsl:value-of select="substring(submission-date, 9, 2)"/>
                        </day>                    
                        <month>
                            <xsl:value-of select="substring(submission-date, 6, 2)"/>
                        </month>
                        <year>
                            <xsl:value-of select="substring(submission-date, 1, 4)"/>
                        </year>
                    </pub-date>
                    
                    <volume><xsl:value-of select="normalize-space(fields/field[@name = 'volnum'])"/></volume>
                    
                    <xsl:if test="fields/field[@name = 'issnum'] !=''">
                        <issue><xsl:value-of select="normalize-space(fields/field[@name = 'issnum'])"/></issue>
                    </xsl:if>
                    
                    <!--Not in out metadata but some of our journals have this-->
                    <!--<issue-title></issue-title>-->
                    
                    <xsl:choose >
                        <xsl:when test="fpage !=''">
                            <fpage><xsl:value-of select="fpage"/></fpage>
                            <lpage><xsl:value-of select="lpage"/></lpage>
                            <!--<page-range/>-->
                        </xsl:when>
                        <xsl:otherwise>
                            <elocation-id><xsl:value-of select="label"/></elocation-id>
                        </xsl:otherwise>
                    </xsl:choose>
                            
                            <!--Could include submission-date if journal uses editorial process
                            <history></history>-->
                    
                    <!--Will need to add coding for subscription/restricted content-->
                    <permissions>
                        <copyright-statement><xsl:value-of select="normalize-space(fields/field[@name = 'rights'])"/></copyright-statement>
<!--                        <copyright-year></copyright-year>
                        <copyright-holder></copyright-holder>-->
                        <ali:free_to_read xmlns:ali="http://www.niso.org/schemas/ali/1.0/"/>
                        <xsl:if test="fields/field[@name = 'distribution_license'] !=''">
                        <license>
                            <ali:license_ref xmlns:ali="http://www.niso.org/schemas/ali/1.0/">
                                <xsl:value-of select="normalize-space(fields/field[@name = 'distribution_license'])"/></ali:license_ref>
                        </license>
                        </xsl:if>
                    </permissions>

                    <!--Not sure if this is a good idea to include-->
                    <self-uri xlink:href="{fulltext-url}">PDF with no cover page</self-uri>
                    
                    <xsl:if test="fields/field[@name = 'relation']!=''">
                        <self-uri xlink:href="{normalize-space(fields/field[@name = 'relation'])}">HTML version of article</self-uri>
                    </xsl:if>
                                   
                    <xsl:if test="abstract !=''">
                        <abstract><xsl:value-of select="normalize-space(abstract)"/></abstract>
                    </xsl:if>
                    
                    <xsl:if test="keywords/keyword !=''">
                        <kwd-group>
                            <xsl:for-each select="keywords/keyword">
                                <kwd><xsl:value-of select="."/></kwd>
                            </xsl:for-each>
                        </kwd-group>
                    </xsl:if>
                    
                    <xsl:if test="fields/field[@name = 'financial_disclosure'] !=''">
                        <funding-group>
                            <award-group/>
                            <funding-statement><xsl:value-of select="normalize-space(fields/field[@name = 'financial_disclosure'])"/></funding-statement>
                            <!--<open-access/>-->
                        </funding-group>
                    </xsl:if>
                    
                    <xsl:if test="fields/field[@name = 'tpages'] !=''">
                        <xsl:variable name="pagecount">
                            <xsl:value-of select="normalize-space(substring-before(fields/field[@name = 'tpages'],' pages'))"/>
                        </xsl:variable>
                        <counts><page-count count="{$pagecount}"/></counts>
                    </xsl:if>
                </article-meta>
            </front>    

        </article>
        <!--</xsl:result-document>-->
                </xsl:result-document>
            </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template> 
</xsl:stylesheet>
