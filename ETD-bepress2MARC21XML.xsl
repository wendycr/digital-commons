<?xml version="1.0" encoding="UTF-8"?>

<!-- Copyright 2012 The University of Iowa
	Originally created by Shawn Averkamp and Joanna Lee
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
-->
<!-- changed record type, country code, contents 260, and 300 per cataloging requests WR 4/20/10 -->
<!-- changed 710 indicator, check for College/Dept, changed advisor to authorized form, putting dates in own subfield. titles (|c) and fuller form of name (|q) not accounted for WR 11/17/11-->
<!-- changed the 502 to omit "thesis" and "dissertation" RPR 11/17/2011-->
<!-- modified because now getting 3 letter language codes and to add illustrations, modified 504 (p.), 006, 700 $4 WCR 11/2/12 -->
<!-- removed 690, removed 538 mode of access, updated for RDA WCR 5/15/13 -->
<!-- changed the 502 to remove punctuations ":" and "," AX 2/4/2015 -->
<!-- modified the 504 to update bibliographical references, AX 2/5/2015 --> 
<!-- modified the 040 to indicate RDA and language, AX 10/12/2015 -->
<!-- changed the 008 to include $$e for detailed date, Wendy 9/2/2016 --> 
<!-- changed the 264 to include $$c for detailed date MM YYYY, Wendy 9/2/2016 --> 
<!-- added department name "School of Journalism and Mass Communication", AX 12/19/2016--> 
<!-- modied 856 to include embargo note, WCR 2017-03-23 -->
<!-- modified 300 and 504 to match RDA, WCR 2017-07-21 -->
<!-- modified 008 for illustrations and bibliography, WCR 2017-08-07 -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.functx.com" extension-element-prefixes="functx">
    <!-- Transform of bepress XML for ETDs to MARC21XML schema  -->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:preserve-space elements="text"/>

    <!-- functx functions used to split abstract (520:3$a) at last period before 1980 characters-->
    <xsl:function name="functx:substring-before-last" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="delim" as="xs:string"/>

        <xsl:sequence
            select=" 
            if (matches($arg, functx:escape-for-regex($delim)))
            then replace($arg,
            concat('^(.*)', functx:escape-for-regex($delim),'.*'),
            '$1')
            else ''
            "
        />
    </xsl:function>

    <!--functx to split advisors last name-->
    <xsl:function name="functx:substring-after-last" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="delim" as="xs:string"/>

        <xsl:sequence
            select=" 
            replace ($arg,concat('^.*',functx:escape-for-regex($delim)),'')
            "
        />
    </xsl:function>


    <!--functx to capitalize first word of keywords-->
    <xsl:function name="functx:capitalize-first" as="xs:string?"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence
            select=" 
            concat(upper-case(substring($arg,1,1)),
            substring($arg,2))
            "
        />
    </xsl:function>



    <xsl:function name="functx:escape-for-regex" as="xs:string" xmlns:functx="http://www.functx.com">
        <xsl:param name="arg" as="xs:string?"/>

        <xsl:sequence
            select=" 
            replace($arg,
            '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
            "
        />
    </xsl:function>


    <xsl:template match="/">
        <marc:collection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
            <xsl:for-each select="documents/document">
                <marc:record>
                    <xsl:variable name="date" select="publication-date"/>
                    <marc:leader>
                        <xsl:text>     nam  22     Ii 4500</xsl:text>
                    </marc:leader>
                    <marc:controlfield tag="006">
                        <xsl:text>m     o  d        </xsl:text>
                    </marc:controlfield>
                    <marc:controlfield tag="007">
                        <xsl:text>cr n||||||||||</xsl:text>
                    </marc:controlfield>

                    <marc:controlfield tag="008">
                        <xsl:text>      </xsl:text>
                        <xsl:choose>
                            <xsl:when test="substring($date, 6, 2)='01'">
                                <xsl:value-of select="concat('s', substring($date, 1, 4),'  ')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('e', substring($date, 1, 4),substring($date, 6, 2))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        <xsl:choose>
                            <xsl:when test="fields/field[@name='illustrations']!=''"> 
                                <xsl:text>  iaua   </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>  iau    </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose> 
                        
                        <xsl:choose>
                             <xsl:when test="fields/field[@name='bibliographic']!=''"> 
                                <xsl:text> obm</xsl:text>
                             </xsl:when>
                             <xsl:otherwise>
                                <xsl:text> om </xsl:text>
                             </xsl:otherwise>
                         </xsl:choose>                             
                        
                        <xsl:variable name="language" select="fields/field[@name='language']/value"/>
                        <xsl:choose>
                            <xsl:when test="$language='eng'">
                                <xsl:text>   000 0 eng d</xsl:text>
                            </xsl:when>
                            <xsl:when test="$language='fre'">
                                <xsl:text>   000 0 fre d</xsl:text>
                            </xsl:when>
                            <xsl:when test="$language='spa'">
                                <xsl:text>   000 0 spa d</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>   000 0 ??? d</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>                      
                    </marc:controlfield>
                   
                    <marc:datafield tag="040" ind1=" " ind2=" ">
                        <marc:subfield code="a">NUI</marc:subfield>
                        <marc:subfield code="b">eng</marc:subfield>
                        <marc:subfield code="e">rda</marc:subfield>
                        <marc:subfield code="c">NUI</marc:subfield>
                    </marc:datafield>
                  
                    <marc:datafield tag="100" ind1="1" ind2=" ">
                        <xsl:variable name="suffix" select="authors/author/suffix"/>
                        <xsl:choose>
                            <xsl:when test="$suffix=''">
                                <marc:subfield code="a">
                                    <xsl:variable name="fname" select="authors/author/fname"/>
                                    <xsl:variable name="mname" select="authors/author/mname"/>
                                    <xsl:variable name="lname" select="authors/author/lname"/>
                                    <xsl:choose>
                                        <xsl:when test="$mname!=''">
                                            <xsl:value-of
                                                select="concat($lname, ', ', $fname, ' ', $mname,',')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat($lname, ', ', $fname,',')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </marc:subfield>
                            </xsl:when>
                            <xsl:otherwise>
                                <marc:subfield code="a">
                                    <xsl:variable name="fname" select="authors/author/fname"/>
                                    <xsl:variable name="mname" select="authors/author/mname"/>
                                    <xsl:variable name="lname" select="authors/author/lname"/>
                                    <xsl:choose>
                                        <xsl:when test="$mname!=''">
                                            <xsl:value-of
                                                select="concat($lname, ', ', $fname, ' ', $mname,',')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat($lname, ', ', $fname,',')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </marc:subfield>                               
                                <marc:subfield code="c">
                                    <xsl:value-of select="concat($suffix,',')"/>
                                </marc:subfield>
                            </xsl:otherwise>
                        </xsl:choose>
                        <marc:subfield code="e">author.</marc:subfield>
                    </marc:datafield>

                    <xsl:variable name="title" select="title"/>
                    <xsl:choose>
                        <xsl:when test="substring($title, 1, 2)='A '">
                            <marc:datafield tag="245" ind1="1" ind2="2">
                                <xsl:call-template name="Title245abc"/>
                            </marc:datafield>
                        </xsl:when>
                        <xsl:when test="substring($title, 1, 3)='An '">
                            <marc:datafield tag="245" ind1="1" ind2="3">
                                <xsl:call-template name="Title245abc"/>
                            </marc:datafield>
                        </xsl:when>
                        <xsl:when test="substring($title, 1, 4)='The '">
                            <marc:datafield tag="245" ind1="1" ind2="4">
                                <xsl:call-template name="Title245abc"/>
                            </marc:datafield>
                        </xsl:when>
                        <xsl:otherwise>
                            <marc:datafield tag="245" ind1="1" ind2="0">
                                <xsl:call-template name="Title245abc"/>
                            </marc:datafield>
                        </xsl:otherwise>
                    </xsl:choose>

                    <marc:datafield tag="264" ind1=" " ind2="1">
                        <marc:subfield code="a">[Iowa City, Iowa] :</marc:subfield>
                        <marc:subfield code="b">University of Iowa,</marc:subfield>
                        <marc:subfield code="c">
                            <xsl:choose>
                                <xsl:when test="substring($date, 6, 2)='05'">
                                    <xsl:value-of select="concat('May ',substring($date, 1, 4), '.')"/>
                                </xsl:when>
                                <xsl:when test="substring($date, 6, 2)='07'">
                                    <xsl:value-of select="concat('July ',substring($date, 1, 4), '.')"/>
                                </xsl:when>
                                <xsl:when test="substring($date, 6, 2)='08'">
                                    <xsl:value-of select="concat('August ',substring($date, 1, 4), '.')"/>
                                </xsl:when>
                                <xsl:when test="substring($date, 6, 2)='12'">
                                    <xsl:value-of select="concat('December ',substring($date, 1, 4), '.')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat(substring($date, 1, 4), '.')"/>
                                </xsl:otherwise>
                            </xsl:choose>                      
                       </marc:subfield>
                    </marc:datafield>

                    <xsl:variable name="tpages" select="fields/field[@name='tpages']/value"/>
                    <xsl:variable name="illustrations" select="fields/field[@name='illustrations']/value"/>
                    <marc:datafield tag="300" ind1=" " ind2=" ">
                        <xsl:choose>
                          <xsl:when test="fields/field[@name='illustrations']!=''">
                              <marc:subfield code="a">
                                  <xsl:value-of select="concat('1 online resource',' (',$tpages,') :')"/>
                              </marc:subfield>
                              <marc:subfield code="b">
                                <xsl:value-of select="$illustrations"/>
                              </marc:subfield>  
                            </xsl:when>
                            <xsl:otherwise>
                                <marc:subfield code="a">
                                    <xsl:value-of select="concat('1 online resource',' (',$tpages,')')"/>
                                </marc:subfield>
                            </xsl:otherwise>
                        </xsl:choose>  
                    </marc:datafield>
                    
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="a">text</marc:subfield>
                        <marc:subfield code="b">txt</marc:subfield>
                        <marc:subfield code="2">rdacontent</marc:subfield>
                    </marc:datafield>
                    
                    <marc:datafield tag="337" ind1=" " ind2=" ">
                        <marc:subfield code="a">computer</marc:subfield>
                        <marc:subfield code="b">c</marc:subfield>
                        <marc:subfield code="2">rdamedia</marc:subfield>
                    </marc:datafield>
                    
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="a">online resource</marc:subfield>
                        <marc:subfield code="b">cr</marc:subfield>
                        <marc:subfield code="2">rdacarrier</marc:subfield>
                    </marc:datafield>
                    
                    <marc:datafield tag="347" ind1=" " ind2=" ">
                        <marc:subfield code="a">text file</marc:subfield>
                        <marc:subfield code="b">PDF</marc:subfield>
                        <marc:subfield code="c">MB</marc:subfield>
                        <marc:subfield code="2">rda</marc:subfield>
                    </marc:datafield>
                  
                    <xsl:variable name="advisortest" select="fields/field[@name='advisor1']/value"/>
                    <xsl:if test="$advisortest!=''">
                        <marc:datafield tag="500" ind1=" " ind2=" ">
                            <marc:subfield code="a">
                                <xsl:value-of
                                    select="concat('Thesis supervisor: ',$advisortest,'.')" />
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>

                    <xsl:variable name="advisortest2" select="fields/field[@name='advisor2']/value"/>
                    <xsl:if test="$advisortest2!=''">
                        <marc:datafield tag="500" ind1=" " ind2=" ">
                            <marc:subfield code="a">
                                <xsl:value-of
                                    select="concat('Thesis supervisor: ',$advisortest2,'.')" />
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                    
                    <xsl:variable name="advisortest3" select="fields/field[@name='advisor3']/value"/>
                    <xsl:if test="$advisortest3!=''">
                        <marc:datafield tag="500" ind1=" " ind2=" ">
                            <marc:subfield code="a">
                                <xsl:value-of
                                    select="concat('Thesis supervisor: ',$advisortest3,'.')" />
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>

                    <marc:datafield tag="502" ind1=" " ind2=" ">

                        <marc:subfield code="b">
                            <xsl:variable name="degreeabbrev" select="degree_name"/>
                            <xsl:choose>
                                <xsl:when test="$degreeabbrev='MA (Master of Arts)'">
                                    <xsl:value-of>M.A.</xsl:value-of>
                                </xsl:when>
                                <xsl:when test="$degreeabbrev='MFA (Master of Fine Arts)'">
                                    <xsl:value-of>M.F.A.</xsl:value-of>
                                </xsl:when>
                                <xsl:when test="$degreeabbrev='MS (Master of Science)'">
                                    <xsl:value-of>M.S.</xsl:value-of>
                                </xsl:when>
                                <xsl:when test="$degreeabbrev='MSN (Master of Science in Nursing)'">
                                    <xsl:value-of>M.S.N.</xsl:value-of>
                                </xsl:when>
                                <xsl:when test="$degreeabbrev='MSW (Master of Social Work)'">
                                    <xsl:value-of>M.S.W.</xsl:value-of>
                                </xsl:when>
                                <xsl:when test="$degreeabbrev='DMA (Doctor of Musical Arts)'">
                                    <xsl:value-of>D.M.A.</xsl:value-of>
                                </xsl:when>
                                <xsl:when test="$degreeabbrev='PhD (Doctor of Philosophy)'">
                                    <xsl:value-of>Ph.D.</xsl:value-of>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="degreeabbrev"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </marc:subfield>
                        <marc:subfield code="c">University of Iowa</marc:subfield>
                        <marc:subfield code="d">
                            <xsl:value-of select="concat(substring($date, 1, 4), '.')"/>
                        </marc:subfield>
                    </marc:datafield>
                                           
                 <xsl:if test="fields/field[@name='bibliographic']!=''">
                        <marc:datafield tag="504" ind1=" " ind2=" ">
                            <marc:subfield code="a">
                                <xsl:value-of
                                    select="normalize-space(fields/field[@name='bibliographic']/value)"
                                />
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if> 
                    
                    <xsl:if test="abstract!=''">
                        <xsl:variable name="abstract">
                            <xsl:for-each select="abstract/p">
                                <xsl:variable name="para" select="."/>
                                <xsl:value-of
                                    select="concat(replace(
                                replace(
                                replace(
                                replace( 
                                replace(
                                replace(
                                replace(
                                replace(
                                replace(
                                replace(normalize-space(concat($para,' ')),'&lt;strong&gt;',' '),
                                '&lt;/strong&gt;',' '),
                                '&lt;em&gt;',' '),
                                '&lt;/em&gt;',' '),
                                '&lt;sup&gt;',' '),
                                '&lt;/sup&gt;',' '),
                                '&lt;sub&gt;',' '),
                                '&lt;/sub&gt;',' '),
                                '–','-'),
                                '—','--'),' ')" 
                                />
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="string-length($abstract)>1980">
                                <xsl:variable name="abstractString"
                                    select="concat(functx:substring-before-last(substring($abstract, 1, 1980), '.'), '.')"/>
                                <marc:datafield tag="520" ind1="3" ind2=" ">
                                    <marc:subfield code="a">
                                        <xsl:value-of select="$abstractString"/>
                                    </marc:subfield>
                                </marc:datafield>
                                <marc:datafield tag="520" ind1="8" ind2=" ">
                                    <marc:subfield code="a">
                                        <xsl:value-of
                                            select="substring($abstract, string-length($abstractString) + 2, string-length($abstractString) + 1980)"
                                        />
                                    </marc:subfield>
                                </marc:datafield>
                            </xsl:when>
                            <xsl:otherwise>
                                <marc:datafield tag="520" ind1="3" ind2=" ">
                                    <marc:subfield code="a">
                                        <xsl:value-of select="$abstract"/>
                                    </marc:subfield>
                                </marc:datafield>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if> 

                    <marc:datafield tag="538" ind1=" " ind2=" ">
                        <marc:subfield code="a">System requirements: Adobe Reader.</marc:subfield>
                    </marc:datafield>

                    <xsl:variable name="rights" select="fields/field[@name='rights']/value"/>
                    <marc:datafield tag="540" ind1=" " ind2=" ">
                        <marc:subfield code="a">
                            <xsl:value-of select="(concat(normalize-space($rights),'.'))"/>
                        </marc:subfield>
                    </marc:datafield>

                    <xsl:if test="comments!=''">
                        <marc:datafield tag="544" ind1=" " ind2=" ">
                            <marc:subfield code="a">University of Iowa Libraries, University Archives</marc:subfield>
                            <marc:subfield code="n">This thesis has been optimized for improved web viewing. If you require the original version, contact the University Archives at the University of Iowa: http://www.lib.uiowa.edu/sc/contact/</marc:subfield>
                        </marc:datafield>
                    </xsl:if>

                    <xsl:variable name="keywordtest" select="keywords/keyword"/>
                    <xsl:if test="$keywordtest!=''">
                        <marc:datafield tag="653" ind1=" " ind2=" ">
                            <xsl:for-each select="keywords/keyword">
                                <xsl:variable name="keyword" select="."/>
                                <marc:subfield code="a">
                                    <xsl:value-of select="(functx:capitalize-first($keyword))"/>
                                </marc:subfield>
                            </xsl:for-each>
                        </marc:datafield>
                    </xsl:if>
                    <marc:datafield tag="655" ind1=" " ind2="7">
                        <marc:subfield code="a">Academic theses.</marc:subfield>
                        <marc:subfield code="2">lcgft</marc:subfield>
                    </marc:datafield>
                    <xsl:variable name="department" select="department"/>
                    <!--School of section-->
                    <xsl:if test="$department='Music'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">
                                <xsl:value-of select="concat('School of ',$department,'.')"/>
                            </marc:subfield>
<!--                            <marc:subfield code="e">
                                <xsl:value-of select="'degree-granting institution'"/>
                            </marc:subfield>-->
                        </marc:datafield>
                    </xsl:if>
                    <xsl:if test="$department='Art'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">School of Art and Art History.</marc:subfield>
                            <!--                            <marc:subfield code="e">
                                <xsl:value-of select="'degree-granting institution'"/>
                            </marc:subfield>-->
                        </marc:datafield>
                    </xsl:if>
                    <xsl:if test="$department='Journalism' or $department='Mass Communications'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">School of Journalism and Mass Communication.</marc:subfield>
                         </marc:datafield>
                    </xsl:if>
                    <xsl:if test="$department='Book Arts'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                           <marc:subfield code="a">Iowa Center for the Book.</marc:subfield>
                            <!--                            <marc:subfield code="e">
                                <xsl:value-of select="'degree-granting institution'"/>
                            </marc:subfield>-->
                        </marc:datafield>
                    </xsl:if>
                    <!--College of section-->
                    <xsl:if test="$department='Nursing' or $department='Pharmacy'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">
                                <xsl:value-of select="concat('College of ',$department,'.')"/>
                            </marc:subfield>
<!--                            <marc:subfield code="e">
                                <xsl:value-of select="'degree-granting institution'"/>
                            </marc:subfield>-->
                        </marc:datafield>
                    </xsl:if>
                   <!-- Physics section-->
                    <xsl:if test="$department='Physics' or $department='Astronomy'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">Department of Physics and Astronomy.</marc:subfield>
                            <!-- <marc:subfield code="e">
                                <xsl:value-of select="'degree-granting institution'"/>
                            </marc:subfield>-->
                        </marc:datafield>
                    </xsl:if>
                    <!-- Psychology section-->
                    <xsl:if test="$department='Psychology'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">Department of Psychological and Brain Sciences.</marc:subfield>
                            <!-- <marc:subfield code="e">
                                <xsl:value-of select="'degree-granting institution'"/>
                            </marc:subfield>-->
                        </marc:datafield>
                    </xsl:if>
                    <!-- Physical Rehabilitation Science -->
                    <xsl:if test="$department='Physical Rehabilitation Science' or $department='Physical Therapy'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">Department of Physical Therapy and Rehabilitation Science.</marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                    <!-- Institute for Clinical & Translational Science-->
                    <xsl:if test="$department='Translational Biomedicine'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">Institute for Clinical and Translational Science.</marc:subfield>
                            <!-- <marc:subfield code="e">
                                <xsl:value-of select="'degree-granting institution'"/>
                            </marc:subfield>-->
                        </marc:datafield>
                    </xsl:if>
                    <!-- French and Francophone World Studies-->
                    <xsl:if test="$department='French and Francophone World Studies'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">Department of French and Italian.</marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                    <!-- Spanish and Portuguese-->
                    <xsl:if test="$department='Spanish'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">Department of Spanish and Portuguese.</marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                    <!-- Geoscience-->
                    <xsl:if test="$department='Geoscience'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">Department of Geographical and Sustainability Sciences.</marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                    <!--Biomedical Engineering-->
                    <xsl:if test="$department='Biomedical Engineering'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">College of Engineering.</marc:subfield>
                            <marc:subfield code="b">Biomedical Engineering.</marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                    <!-- Second Language Acquisition -->
                    <xsl:if test="$department='Second Language Acquisition'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">Department of Linguistics.</marc:subfield>
                        </marc:datafield>
                    </xsl:if>  
                    <!-- Film and Video Production and Film Studies -->
                    <xsl:if test="$department='Film and Video Production' or $department='Film Studies'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">Department of Cinematic Arts.</marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                    <!-- Speech Pathology and Audiology -->
                    <xsl:if test="$department='Speech Pathology and Audiology'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">Department of Communication Sciences and Disorders.</marc:subfield>
                        </marc:datafield>
                    </xsl:if>   
                    <!--Interdisciplinary program section-->
                    <xsl:if test="$department='Applied Mathematical and Computational Sciences' or $department='Molecular and Cellular Biology' or $department='Genetics' or $department='Human Toxicology' or $department='Immunology' or $department='Neuroscience'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">
                                <xsl:value-of select="concat('Interdisciplinary Graduate Program in ',$department,'.')"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                     <!--Program section -->
                    <xsl:if test="$department='Free Radical and Radiation Biology' or $department='Science Education'">
                                <marc:datafield tag="710" ind1="2" ind2=" ">
                                    <marc:subfield code="a">University of Iowa.</marc:subfield>
                                    <marc:subfield code="b">
                                        <xsl:value-of select="concat($department,' Program.')"/>
                                    </marc:subfield>
                                </marc:datafield>
                            </xsl:if>
                    <!--Graduate program section -->
                    <xsl:if test="$department='Oral Science'or $department='Dental Public Health'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">
                                <xsl:value-of select="concat($department,' Graduate Program.')"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                    <!--Department of section-->
                    <xsl:if test="$department!='Applied Mathematical and Computational Sciences' and $department!='Book Arts'and $department!='Physical Rehabilitation Science' and $department!='Physical Therapy' and $department!='Dental Public Health' and $department!='Oral Science' and $department!='French and Francophone World Studies' and $department!='Astronomy' and $department!='Translational Biomedicine' and $department!='Science Education' and $department!='Free Radical and Radiation Biology' and $department!='Music' and $department!='Pharmacy' and $department!='Art' and $department!='Nursing' and $department!='Physics' and $department!='Psychology' and $department!='Molecular and Cellular Biology' and $department!='Genetics' and $department!='Human Toxicology' and $department!='Immunology' and $department!='Neuroscience' and $department!='Spanish' and $department!='Geoscience'and $department!='Biomedical Engineering' and $department!='Film and Video Production' and $department!='Film Studies' and $department!='Journalism' and $department!='Mass Communications'and $department!='Speech Pathology and Audiology'">
                        <marc:datafield tag="710" ind1="2" ind2=" ">
                            <marc:subfield code="a">University of Iowa.</marc:subfield>
                            <marc:subfield code="b">
                                <xsl:value-of select="concat('Department of ',$department,'.')"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>

                    <xsl:variable name="advisortest"
                        select="fields/field[@name='alt_advisor1']/value"/>
                    <xsl:if test="$advisortest!=''">
                        <xsl:for-each select="fields/field[@name='alt_advisor1']/value">

                            <xsl:variable name="advisor" select="."/>

                            <marc:datafield tag="700" ind1="1" ind2=" ">

                                          <xsl:choose>
                                            <xsl:when test="contains(.,'19')">
                                                <marc:subfield code="a">
                                                  <xsl:value-of
                                                  select="functx:substring-before-last($advisor,', ')"
                                                  />
                                                </marc:subfield>
                                                <marc:subfield code="d">
                                                  <xsl:value-of
                                                  select="functx:substring-after-last($advisor,', ')"
                                                  />
                                                </marc:subfield>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <marc:subfield code="a">
                                                    <xsl:value-of select="concat(normalize-space($advisor),',')"/>
                                                </marc:subfield>                                          
                                            </xsl:otherwise>
                                        </xsl:choose>

                                <marc:subfield code="e">
                                    <xsl:value-of select="'thesis advisor.'"/>
                                </marc:subfield>

                            </marc:datafield>
                        </xsl:for-each>
                    </xsl:if>

                    <xsl:variable name="advisortest2"
                        select="fields/field[@name='alt_advisor2']/value"/>
                    <xsl:if test="$advisortest2!=''">
                        <xsl:for-each select="fields/field[@name='alt_advisor2']/value">

                            <xsl:variable name="advisor" select="."/>
                            <marc:datafield tag="700" ind1="1" ind2=" ">

                                          <xsl:choose>
                                            <xsl:when test="contains(.,'19')">
                                                <marc:subfield code="a">
                                                  <xsl:value-of
                                                  select="functx:substring-before-last($advisor,' ')"
                                                  />
                                                </marc:subfield>
                                                <marc:subfield code="d">
                                                  <xsl:value-of
                                                  select="functx:substring-after-last($advisor,', ')"
                                                  />
                                                </marc:subfield>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <marc:subfield code="a">
                                                    <xsl:value-of select="concat(normalize-space($advisor),',')"/>
                                                </marc:subfield>                                          
                                            </xsl:otherwise>
                                          </xsl:choose>
                                
                                <marc:subfield code="e">
                                    <xsl:value-of select="'thesis advisor.'"/>
                                </marc:subfield>


                            </marc:datafield>                        </xsl:for-each>
                    </xsl:if>

                    <xsl:variable name="advisortest3"
                        select="fields/field[@name='alt_advisor3']/value"/>
                    <xsl:if test="$advisortest3!=''">
                        <xsl:for-each select="fields/field[@name='alt_advisor3']/value">

                            <xsl:variable name="advisor" select="."/>
                            <marc:datafield tag="700" ind1="1" ind2=" ">

                                          <xsl:choose>
                                            <xsl:when test="contains(.,'19')">
                                                <marc:subfield code="a">
                                                  <xsl:value-of
                                                  select="functx:substring-before-last($advisor,' ')"
                                                  />
                                                </marc:subfield>
                                                <marc:subfield code="d">
                                                  <xsl:value-of
                                                  select="functx:substring-after-last($advisor,', ')"
                                                  />
                                                </marc:subfield>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <marc:subfield code="a">
                                                    <xsl:value-of select="concat(normalize-space($advisor),',')"/>
                                                </marc:subfield>                                          
                                            </xsl:otherwise>
                                          </xsl:choose>
                                
                                <marc:subfield code="e">
                                    <xsl:value-of select="'thesis advisor.'"/>
                                </marc:subfield>

                            </marc:datafield>
                        </xsl:for-each>
                    </xsl:if>
                    
                    <marc:datafield tag="856" ind1="4" ind2="0">
                        <marc:subfield code="u">
                            <xsl:variable name="label" select="label"/>
                            <xsl:value-of select="concat('http://ir.uiowa.edu/etd/', $label)"/>
                        </marc:subfield>
                        
                        <xsl:variable name="yyyy" select="substring(fields/field[@name='embargo_date']/value,1,4)"/>
                        <xsl:variable name="mm" select="substring(fields/field[@name='embargo_date']/value,6,2)"/>
                        <xsl:variable name="dd" select="substring(fields/field[@name='embargo_date']/value,9,2)"/>                      
                        <xsl:variable name="mon">
                            <xsl:choose>
                                <xsl:when test="$mm='01'">
                                    <xsl:value-of select="'January'" />
                                </xsl:when>
                                <xsl:when test="$mm='02'">
                                    <xsl:value-of select="'February'" />
                                </xsl:when>
                                <xsl:when test="$mm='03'">
                                    <xsl:value-of select="'March'" />
                                </xsl:when>
                                <xsl:when test="$mm='04'">
                                    <xsl:value-of select="'April'" />
                                </xsl:when>
                                <xsl:when test="$mm='05'">
                                    <xsl:value-of select="'May'" />
                                </xsl:when>
                                <xsl:when test="$mm='06'">
                                    <xsl:value-of select="'June'" />
                                </xsl:when>
                                <xsl:when test="$mm='07'">
                                    <xsl:value-of select="'July'" />
                                </xsl:when>
                                <xsl:when test="$mm='08'">
                                    <xsl:value-of select="'August'" />
                                </xsl:when>
                                <xsl:when test="$mm='09'">
                                    <xsl:value-of select="'September'" />
                                </xsl:when>
                                <xsl:when test="$mm='10'">
                                    <xsl:value-of select="'October'" />
                                </xsl:when>
                                <xsl:when test="$mm='11'">
                                    <xsl:value-of select="'November'" />
                                </xsl:when>
                                <xsl:when test="$mm='12'">
                                    <xsl:value-of select="'December'" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'error'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:if test="fields/field[@name='embargo_date']!=''">                            
                            <marc:subfield code="z">
                                <xsl:value-of select="concat('This thesis has been embargoed from public view until ',$mon,' ',$dd,', ',$yyyy,'.')"/>
                            </marc:subfield>
                        </xsl:if>
                        
                    </marc:datafield>
                    <!-- </xsl:for-each> needed in subject specific filess -->
                </marc:record>
            </xsl:for-each>
        </marc:collection>
    </xsl:template>

    <!-- template to split remainder of title (245$b) from title at ":", "?", or "?:" -->
    <xsl:template name="Title245abc">
        <xsl:param name="theTitle" select="title"/>
        <xsl:choose>
            <xsl:when test="contains($theTitle,':')">
                <marc:subfield code="a">
                    <xsl:value-of select="concat(normalize-space(substring-before($theTitle, ':')),' :')"/>
                    <!--                    <xsl:text> :</xsl:text>-->
                </marc:subfield>
                <marc:subfield code="b">
                    <xsl:value-of
                        select="normalize-space(concat(substring-after($theTitle, ':'),' /'))"/>
                </marc:subfield>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="contains($theTitle, '?')">
                        <marc:subfield code="a">
                            <xsl:value-of select="normalize-space(substring-before($theTitle, '?'))"/>
                            <xsl:text>? :</xsl:text>
                        </marc:subfield>
                        <marc:subfield code="b">
                            <xsl:value-of
                                select="normalize-space(concat(substring-after($theTitle,'?'),' /'))"
                            />
                        </marc:subfield>
                    </xsl:when>
                    <xsl:otherwise>
                        <marc:subfield code="a">
                            <xsl:value-of select="normalize-space(concat($theTitle,' /'))"/>
                        </marc:subfield>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <marc:subfield code="c">
            <xsl:variable name="fname" select="authors/author/fname"/>
            <xsl:variable name="mname" select="authors/author/mname"/>
            <xsl:variable name="lname" select="authors/author/lname"/>
            <xsl:variable name="suffix" select="authors/author/suffix"/>
            <xsl:choose>
                <xsl:when test="$suffix=''">
                    <xsl:choose>
                            <xsl:when test="$mname!=''">
                                <xsl:value-of select="concat('by ', $fname, ' ', $mname, ' ', $lname, '.')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('by ', $fname, ' ', $lname, '.')"/>
                            </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$mname!=''">
                            <xsl:value-of select="concat('by ', $fname, ' ', $mname, ' ', $lname, ', ', $suffix, '.')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('by ', $fname, ' ', $lname, ', ', $suffix, '.')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </marc:subfield>
    </xsl:template>
</xsl:stylesheet>
