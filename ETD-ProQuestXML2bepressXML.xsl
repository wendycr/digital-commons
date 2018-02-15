<?xml version='1.0' encoding="UTF-8" ?>

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
	along with this program.  If not, see <http://www.gnu.org/licenses/>. -->
	
<!--
	1/15/10 - removed title case option from names (author and advisor) to retain capilization as input since most were not in all caps; 
	added bibliographic page number section; added note for optimized pdf; standardized degree names, added document-type and disciplines, replaced encoding in abstract,
	changed title to only change case if no lower case vowels
	4/29/10 - changed encoding to UTF-8; added language
	7/7/10 moved local fields to degree name, department, language; added abstract_format
	3/7/17 - modified references to bepress xsd, added embargo information, etc
	6/29/17 - altered pages and bibliographic references to more closely align with cataoging rules
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://www.metaphoricalweb.org/xmlns/string-utilities"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	
		<xsl:output method="xml" indent="yes" />

	<!-- Transform of ProQuest XML (http://media2.proquest.com/documents/ftp_submissions.pdf) to Digital Commons XML Schema for Electronic Theses and Dissertations (ETDs) -->

	<!-- function to transform title from all caps to title case (stopwords included) -->
	<xsl:function name="str:title-case" as="xs:string">
		<xsl:param name="expr"/>
		<xsl:variable name="tokens" select="tokenize($expr, '(~)|( )')"/>
		<xsl:variable name="titledTokens"
			select="for $token in $tokens return 
			concat(upper-case(substring($token,1,1)),
			lower-case(substring($token,2)))"/>
		<xsl:value-of select="$titledTokens"/>
	</xsl:function>

	<xsl:template match="/">
		<documents xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:noNamespaceSchemaLocation="http://resources.bepress.com/document-import.xsd">

			<xsl:for-each select="xml/DISS_submission">
				<document>

					<title>
						<xsl:variable name="title" select="DISS_description/DISS_title"/>

						<xsl:choose>
							<xsl:when test="contains($title,'a')">
								<xsl:value-of select="normalize-space($title)"/>
							</xsl:when>
							<xsl:when test="contains($title,'e')">
								<xsl:value-of select="normalize-space($title)"/>
							</xsl:when>
							<xsl:when test="contains($title,'i')">
								<xsl:value-of select="normalize-space($title)"/>
							</xsl:when>
							<xsl:when test="contains($title,'o')">
								<xsl:value-of select="normalize-space($title)"/>
							</xsl:when>
							<xsl:when test="contains($title,'u')">
								<xsl:value-of select="normalize-space($title)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="title" select="DISS_description/DISS_title"/>
								<xsl:variable name="hyphentitle" select="replace($title, '-', '-~')"/>
								<xsl:value-of
									select="normalize-space(replace(str:title-case(($hyphentitle)), '- ', '-'))"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</title>

					<!-- We've used DISS_comp_date as our publication date, which is generally represented as yyyy, but if DISS_accept_date is preferred, this will transform date to ISO 8601 format (yyyy-mm-dd). Change the date in the otherwise to match the month on the majority of the theses -->
					<publication-date>
						<xsl:variable name="datestr">
							<xsl:value-of select="DISS_description/DISS_dates/DISS_comp_date"/>
						</xsl:variable>
						<!--Add the appropriate numeral for the semester either (05, 07 OR 08 (as appropriate), or 12) in place of the XXX-->
						<xsl:value-of select="concat($datestr,'-XXX-01')"/>
					</publication-date>
					
					<!-- Each sememster, alter the XXX below to be Fall, Spring or Summer as appropriate. Note that if any found to be incorrect when cataloging, IRO should also be corrected. Be sure to also alter the date above (Dec = fall, May = spring, July/August = summer)-->
					<season>XXX</season>

					<!-- Author -->
					<authors>
						<xsl:for-each select="DISS_authorship/DISS_author">
							<author xsi:type="individual">
								<email>
									<xsl:value-of select="DISS_contact[2]/DISS_email"/>
								</email>
								<institution>University of Iowa</institution>
								<lname>
									<xsl:value-of select="DISS_name/DISS_surname"/>
								</lname>
								<fname>
									<xsl:value-of select="DISS_name/DISS_fname"/>
								</fname>
								<mname>
									<xsl:value-of select="DISS_name/DISS_middle"/>
								</mname>
								<suffix>
									<xsl:value-of select="DISS_name/DISS_suffix"/>
								</suffix>
							</author>
						</xsl:for-each>
					</authors>

					<!-- If a new department is added or a mapping is changed besure to update the master excel list on sharepoint -->
					<disciplines>
						<xsl:for-each select="DISS_description/DISS_institution/DISS_inst_contact">
							<discipline>
								<xsl:variable name="department">
									<xsl:value-of select="."/>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="$department='African American World Studies'">
										<xsl:value-of>African American Studies</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='American Studies'">
										<xsl:value-of>American Studies</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Anatomy and Cell Biology'">
										<xsl:value-of>Cell Anatomy</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Anthropology'">
										<xsl:value-of>Anthropology</xsl:value-of>
									</xsl:when>
									<xsl:when
										test="$department='Applied Mathematical &amp; Computational Sciences'">
										<xsl:value-of>Applied Mathematics</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Art'">
										<xsl:value-of>Art Practice</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Art History'">
										<xsl:value-of>History of Art, Architecture, and Archaeology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Asian Civilizations'">
										<xsl:value-of>Asian Studies</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Astronomy'">
										<xsl:value-of>Astrophysics and Astronomy</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Biochemistry'">
										<xsl:value-of>Biochemistry</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Biology'">
										<xsl:value-of>Biology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Biomedical Engineering'">
										<xsl:value-of>Biomedical Engineering and Bioengineering</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Biostatistics'">
										<xsl:value-of>Biostatistics</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Book Arts'">
										<xsl:value-of>Book and Paper</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Business Administration'">
										<xsl:value-of>Business Administration, Management, and Operations</xsl:value-of>
									</xsl:when>
									<xsl:when
										test="$department='Chemical &amp; Biochemical Engineering'">
										<xsl:value-of>Chemical Engineering</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Chemistry'">
										<xsl:value-of>Chemistry</xsl:value-of>
									</xsl:when>
									<xsl:when
										test="$department='Civil &amp; Environmental Engineering'">
										<xsl:value-of>Civil and Environmental Engineering</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Classics'">
										<xsl:value-of>Classics</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Clinical Investigation'">
										<xsl:value-of>Health Services Research</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Communication Studies'">
										<xsl:value-of>Communication</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Community &amp; Behavioral Health'">
										<xsl:value-of>Community Health</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Comparative Literature'">
										<xsl:value-of>Comparative Literature</xsl:value-of>
									</xsl:when>
									<xsl:when
										test="$department='Comparative Literature-Translation'">
										<xsl:value-of>Comparative Literature</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Computer Science'">
										<xsl:value-of>Computer Sciences</xsl:value-of>
									</xsl:when>
									<xsl:when
										test="$department='Counseling, Rehabilitation and Student Development'">
										<xsl:value-of>Student Counseling and Personnel Services</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Dance'">
										<xsl:value-of>Dance</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Dental Public Health'">
										<xsl:value-of>Dental Public Health and Education</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Economics'">
										<xsl:value-of>Economics</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Education'">
										<xsl:value-of>Education</xsl:value-of>
									</xsl:when>
									<xsl:when
										test="$department='Educational Policy &amp; Leadership Studies'">
										<xsl:value-of>Educational Administration and Supervision</xsl:value-of>
									</xsl:when>
									<xsl:when
										test="$department='Electrical and Computer Engineering'">
										<xsl:value-of>Electrical and Computer Engineering</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='English'">
										<xsl:value-of>English Language and Literature</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Epidemiology'">
										<xsl:value-of>Clinical Epidemiology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Exercise Science'">
										<xsl:value-of>Exercise Physiology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Film &amp; Video Production'">
										<xsl:value-of>Film and Media Studies</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Film Studies'">
										<xsl:value-of>Film and Media Studies</xsl:value-of>
									</xsl:when>
									<xsl:when
										test="$department='Free Radical and Radiation Biology'">
										<xsl:value-of>Other Biochemistry, Biophysics, and Structural Biology</xsl:value-of>
									</xsl:when>
									<xsl:when
										test="$department='French and Francophone World Studies'">
										<xsl:value-of>French and Francophone Language and Literature</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Genetics'">
										<xsl:value-of>Genetics</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Geography'">
										<xsl:value-of>Geography</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Geoscience'">
										<xsl:value-of>Geology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='German'">
										<xsl:value-of>German Language and Literature</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Greek'">
										<xsl:value-of>Ancient History, Greek and Roman through Late Antiquity</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Health and Sport Studies'">
										<xsl:value-of>Exercise Physiology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Health Management and Policy'">
										<xsl:value-of>Health Services Administration</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Health Services &amp; Policy'">
										<xsl:value-of>Health Services Administration</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='History'">
										<xsl:value-of>History</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Human Toxicology'">
										<xsl:value-of>Toxicology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Immunology'">
										<xsl:value-of>Immunology of Infectious Disease</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Industrial Engineering'">
										<xsl:value-of>Industrial Engineering</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Informatics'">
										<xsl:value-of>Bioinformatics</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Integrative Physiology'">
										<xsl:value-of>Systems and Integrative Physiology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='International Studies'">
										<xsl:value-of>International and Area Studies</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Interdisciplinary Studies'">FIX MANUALLY: <xsl:value-of select="$department"/>
									</xsl:when>
									<xsl:when test="$department='Journalism'">
										<xsl:value-of>Journalism Studies</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Latin'">
										<xsl:value-of>Ancient History, Greek and Roman through Late Antiquity</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Leisure Studies'">
										<xsl:value-of>Leisure Studies</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Library and Information Science'">
										<xsl:value-of>Library and Information Science</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Linguistics'">
										<xsl:value-of>Linguistics</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Mass Communications'">
										<xsl:value-of>Mass Communication</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Mathematics'">
										<xsl:value-of>Mathematics</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Mechanical Engineering'">
										<xsl:value-of>Mechanical Engineering</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Microbiology'">
										<xsl:value-of>Microbiology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Molecular &amp; Cell Biology'">
										<xsl:value-of>Cell Biology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Molecular Biology'">
										<xsl:value-of>Molecular Biology</xsl:value-of>
									</xsl:when>
									<xsl:when
										test="$department='Molecular Physiology &amp; Biophysics'">
										<xsl:value-of>Biophysics</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Music'">
										<xsl:value-of>Music</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Neuroscience'">
										<xsl:value-of>Neuroscience and Neurobiology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Nursing'">
										<xsl:value-of>Nursing</xsl:value-of>
									</xsl:when>
									<xsl:when
										test="$department='Occupational and Environmental Health'">
										<xsl:value-of>Occupational Health and Industrial Hygiene</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Operative Dentistry'">
										<xsl:value-of>Other Dentistry</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Oral &amp; Maxillofacial Surgery'">
										<xsl:value-of>Oral/Maxillofacial Surgery</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Oral Science'">
										<xsl:value-of>Oral Biology and Oral Pathology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Orthodontics'">
										<xsl:value-of>Orthodontics and Orthodontology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Pathology'">
										<xsl:value-of>Pathology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Pharmacology'">
										<xsl:value-of>Pharmacology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Pharmacy'">
										<xsl:value-of>Pharmacy and Pharmaceutical Sciences</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Pharmaceutical Sciences and Experimental Therapeutics'">
										<xsl:value-of>Pharmacy and Pharmaceutical Sciences</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Philosophy'">
										<xsl:value-of>Philosophy</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Physical Rehabilitation Science'">
										<xsl:value-of>Rehabilitation and Therapy</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Physical Therapy'">
										<xsl:value-of>Physical Therapy</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Physics'">
										<xsl:value-of>Physics</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Physiology and Biophysics'">
										<xsl:value-of>Physiology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Political Science'">
										<xsl:value-of>Political Science</xsl:value-of>
									</xsl:when>
									<xsl:when
										test="$department='Psychological &amp; Quantitative Foundations'">
										<xsl:value-of>Educational Psychology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Psychology'">
										<xsl:value-of>Psychology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Rehabilitation &amp; Counselor Education'">
										<xsl:value-of>Vocational Rehabilitation Counseling</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Religious Studies'">
										<xsl:value-of>Religion</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Science Education'">
										<xsl:value-of>Science and Mathematics Education</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Second Language Acquisition'">
										<xsl:value-of>First and Second Language Acquisition</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Social Work'">
										<xsl:value-of>Clinical and Medical Social Work</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Sociology'">
										<xsl:value-of>Sociology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Spanish'">
										<xsl:value-of>Spanish and Portuguese Language and Literature</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Spanish Creative Writing'">
										<xsl:value-of>Spanish and Portuguese Language and Literature</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Speech &amp; Hearing Science'">
										<xsl:value-of>Speech and Hearing Science</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Speech Pathology and Audiology'">
										<xsl:value-of>Speech Pathology and Audiology</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Statistical Genetics'">
										<xsl:value-of>Other Genetics and Genomics</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Statistics'">
										<xsl:value-of>Statistics and Probability</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Stomatology'">
										<xsl:value-of>Other Dentistry</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Teaching &amp; Learning'">
										<xsl:value-of>Teacher Education and Professional Development</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Theatre Arts'">
										<xsl:value-of>Theatre and Performance Studies</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Translational Biomedicine'">
										<xsl:value-of>Other Biomedical Engineering and Bioengineering</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Urban and Regional Planning'">
										<xsl:value-of>Urban Studies and Planning</xsl:value-of>
									</xsl:when>
									<xsl:when test="$department='Womens Studies'">
										<xsl:value-of>Women’s Studies</xsl:value-of>
									</xsl:when>
									<xsl:otherwise>FIX and NOTIFY Wendy to fix IRO series collection and Amanda to add above, to mapping spreadsheet, modify MARC xsl division, and 710: <xsl:value-of select="$department"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</discipline>
						</xsl:for-each>
					</disciplines>

					<!-- Outputs each keyword into its own keyword element , splitting on both semicolon and comma-->
					<keywords>
						<xsl:for-each select="DISS_description/DISS_categorization/DISS_keyword">
							<xsl:variable name="keywordstring">
								<xsl:value-of select="translate(., ';', ',')"/>
							</xsl:variable>
							<xsl:variable name="tokenkeyword"
								select="tokenize($keywordstring, ',\s+')"/>
							<xsl:for-each select="$tokenkeyword">
								<keyword>
									<xsl:value-of select="."/>
								</keyword>
							</xsl:for-each>
						</xsl:for-each>
					</keywords>

					<!-- Abstract  - replaces ProQuest formatting characters to bepress formatting -->
					<abstract>
						<xsl:for-each select="DISS_content/DISS_abstract">
							<xsl:for-each select="DISS_para">
								<p>
									<xsl:value-of
										select="concat(normalize-space(replace(
										replace(
										replace(
										replace(
										replace(
										replace(
										replace(
										replace(.,'&lt;bold&gt;','&lt;strong&gt;'),
										'&lt;/bold&gt;','&lt;/strong&gt;'),
										'&lt;italic&gt;','&lt;em&gt;'),
										'&lt;/italic&gt;','&lt;/em&gt;'),
										'&lt;super&gt;','&lt;sup&gt;'),
										'&lt;/super&gt;','&lt;/sup&gt;'),
										'&lt;underline&gt;',' '),
										'&lt;/underline&gt;',' ')),' ')"
									/>
								</p>
							</xsl:for-each>
						</xsl:for-each>
					</abstract>

					<!-- adds note indicating that pdf has been optimized -->
					<xsl:choose>
						<xsl:when test="DISS_content/DISS_binary='XXX PASTE HERE'">
							<comments>This thesis has been optimized for improved web viewing. If
								you require the original version, contact the University Archives at
								the University of Iowa: &lt;a
								href="http://www.lib.uiowa.edu/sc/contact/"&gt;http://www.lib.uiowa.edu/sc/contact/&#60;/a&#62;
							</comments>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>

					<!-- constructs the filepath for the server location of the pdf  NEED TO EDIT SO -o IS ADDED TO PDF NAME for optimized  -->
					<fulltext-url>
						<xsl:choose>
							<xsl:when test="DISS_content/DISS_binary='XXX PASTE HERE'">
								<xsl:variable name="pdfname">
									<xsl:value-of
										select="substring-before(DISS_content/DISS_binary,'.pdf')"/>
								</xsl:variable>
								<xsl:value-of
									select="concat('http://sdrc.lib.uiowa.edu/ETDUploads/etd/',$pdfname,'-o.pdf')"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="pdfpath">
									<xsl:value-of select="DISS_content/DISS_binary"/>
								</xsl:variable>
								<xsl:value-of
									select="concat('http://sdrc.lib.uiowa.edu/ETDUploads/etd/', $pdfpath)"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</fulltext-url>

					<!-- Forces bepress article id on each ETD in order to construct the access URL for use in MARC21XML transformation, using number in ETD URL of most recently added ETD -->
					<label>
						<xsl:value-of select="position()+XXX"/>
					</label>

					<!-- Adds document type -->
					<document-type>
						<xsl:for-each
							select="DISS_description/DISS_institution/DISS_processing_code">
							<xsl:variable name="degreetype">
								<xsl:value-of select="."/>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="starts-with($degreetype,'D')">
									<xsl:value-of>dissertation</xsl:value-of>
								</xsl:when>
								<xsl:when test="starts-with($degreetype,'M')">
									<xsl:value-of>thesis</xsl:value-of>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$degreetype"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</document-type>

					<!-- Normalizes degree names -->
					<degree_name>
						<xsl:for-each select="DISS_description/DISS_degree">
							<xsl:variable name="degreestr1">
								<xsl:value-of select="."/>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$degreestr1='M.A.'">
									<xsl:value-of>MA (Master of Arts)</xsl:value-of>
								</xsl:when>
								<xsl:when test="$degreestr1='M.F.A.'">
									<xsl:value-of>MFA (Master of Fine Arts)</xsl:value-of>
								</xsl:when>
								<xsl:when test="$degreestr1='M.S.'">
									<xsl:value-of>MS (Master of Science)</xsl:value-of>
								</xsl:when>
								<xsl:when test="$degreestr1='M.S.N.'">
									<xsl:value-of>MSN (Master of Science in Nursing)</xsl:value-of>
								</xsl:when>
								<xsl:when test="$degreestr1='M.S.W.'">
									<xsl:value-of>MSW (Master of Social Work)</xsl:value-of>
								</xsl:when>
								<xsl:when test="$degreestr1='D.M.A.'">
									<xsl:value-of>DMA (Doctor of Musical Arts)</xsl:value-of>
								</xsl:when>
								<xsl:when test="$degreestr1='Ph.D.'">
									<xsl:value-of>PhD (Doctor of Philosophy)</xsl:value-of>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$degreestr1"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</degree_name>

					<!-- Normalizes department names -->
					<department>
						<xsl:for-each select="DISS_description/DISS_institution/DISS_inst_contact">
							<xsl:variable name="deptstring">
								<xsl:value-of select="."/>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="contains($deptstring, '&amp;')">
									<xsl:value-of select="replace($deptstring, '&amp;', 'and')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$deptstring"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</department>

					<!-- add abstract format  -->
					<abstract_format>html</abstract_format>

					<fields>
						<!-- adds embargo date - In Proquest, 0 - corresponds to no embargo; 1 - 6 months embargo; 2 - 1 year embargo; 3 - 2 year embargo  -->
						<!-- change the embargo dates below according to the Graduate College's decision - use format YYYY-MM-DD -->	
						
<!--						<xsl:variable name="embargo">
							<xsl:choose>
								<xsl:when test="@embargo_code='1'"> <!-\- 6 month -\->
									<xsl:value-of>2017-08-31</xsl:value-of>
								</xsl:when>
								<xsl:when test="@embargo_code='2'"> <!-\- 1 year -\->
									<xsl:value-of>2018-02-28</xsl:value-of>
								</xsl:when>
								<xsl:when test="@embargo_code='3'"> <!-\- 2 years -\->
									<xsl:value-of>2019-02-28</xsl:value-of>
								</xsl:when>
								<xsl:when test="@embargo_code='4'"> <!-\- Until specified date - see DISS_delayed_release -\->
									<xsl:value-of>FIX</xsl:value-of>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>-->							
						
						<xsl:if test="DISS_restriction/DISS_sales_restriction/@remove">
							
						<xsl:variable name="yyyy" select="substring(DISS_restriction/DISS_sales_restriction/@remove,7,4)"/>
						<xsl:variable name="mm" select="substring(DISS_restriction/DISS_sales_restriction/@remove,1,2)"/>
						<xsl:variable name="dd" select="substring(DISS_restriction/DISS_sales_restriction/@remove,4,2)"/>
				
						<field name="embargo_date" type="date">
							<value>
								<xsl:value-of select="concat($yyyy,'-',$mm,'-',$dd)"/>
							</value>
						</field>
					
						<!-- Adds note about embargo date -->
						<field name="access" type="string">
							<value>
								<xsl:text>Access restricted until </xsl:text>
								<xsl:value-of select="DISS_restriction/DISS_sales_restriction/@remove"/>
							</value>
						</field>
							
						</xsl:if>	
						
						<!-- Rights info -->
						<field name="rights" type="string">
							<value>
								<xsl:value-of select="normalize-space(concat('Copyright © ',DISS_description/DISS_dates/DISS_comp_date,' ',DISS_authorship/DISS_author/DISS_name/DISS_fname,' ',DISS_authorship/DISS_author/DISS_name/DISS_middle,' ',DISS_authorship/DISS_author/DISS_name/DISS_surname,' ',DISS_authorship/DISS_author/DISS_name/DISS_suffix))"/>
							</value>
						</field>

						<!-- Pages numbers (from actual length of PDF, not based on page numbering) -->
						<field name="tpages" type="string">
							<value>
								<xsl:value-of select="concat(DISS_description/@page_count,' pages')"/>
							</value>
						</field>
						
						<!-- Illustrations as placeholder for MARC -->
						<field name="illustrations" type="string">
							<value></value>
						</field>

						<!-- Pages numbers for bibliographic references as placeholder for MARC -->
						<field name="bibliographic" type="string">
							<value>Includes bibliographical references (pages ).</value>
						</field>
												
						<!-- Advisors (up to 3 captured) -->
						<xsl:call-template name="advisor"/>
						
						<xsl:call-template name="advisor-date"/>
						
						<!-- add language - add additional spelled out forms of ISO 639-1 codes as needed -->
						<field name="language" type="string">
							<value>
								<xsl:for-each
									select="DISS_description/DISS_categorization/DISS_language">
									<xsl:variable name="lang">
										<xsl:value-of select="."/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="$lang='en'">
											<xsl:value-of>eng</xsl:value-of>
										</xsl:when>
										<xsl:when test="$lang='fr'">
											<xsl:value-of>fre</xsl:value-of>
										</xsl:when>
										<xsl:when test="$lang='es'">
											<xsl:value-of>spa</xsl:value-of>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$lang"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</value>
						</field>
						
						<!-- Degree type -->
						<field name="degree_level" type="string">
							<value>
								<xsl:for-each
									select="DISS_description/DISS_institution/DISS_processing_code">
									<xsl:variable name="degreetype">
										<xsl:value-of select="."/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="starts-with($degreetype,'D')">
											<xsl:value-of>doctoral</xsl:value-of>
										</xsl:when>
										<xsl:when test="starts-with($degreetype,'M')">
											<xsl:value-of>master's</xsl:value-of>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$degreetype"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</value>
						</field>						
						
						<!-- Place holder for public abstract -->
						<field name="publicabstract" type="string">
							<value></value>
						</field>						
						
						<!-- ISNI for author's instituion -->
						<field name="author_institution_id" type="string">
							<value>http://isni.org/0000000419368294</value>
						</field>
						
						<!-- Defines display of date -->
						<field name="publication_date_date_format" type="string">
							<value>SSSS-YYYY</value>
						</field>
						
						<field name="dc_format" type="string">
							<value>application/pdf</value>
						</field>
						
						<field name="dc_type" type="string">
							<value>Text</value>
						</field>
						
						<field name="publisher" type="string">
							<value>University of Iowa</value>
						</field>
						
						<field name="repository" type="string">
							<value>Iowa Research Online, the University of Iowa</value>
						</field>
						
						<field name="degree_grantor" type="string">
							<value>University of Iowa</value>
						</field>
						<field name="degree_grantor_id" type="string">
							<value>http://isni.org/0000000419368294</value>
						</field>
						
					</fields>
				</document>
			</xsl:for-each>
		</documents>
	</xsl:template>
	<xsl:template match="DISS_description" name="advisor-date">
		<xsl:if test="DISS_description/DISS_advisor[1]">
			<field name="alt_advisor1" type="string">
				<value>
					<xsl:variable name="fname">
						<xsl:value-of select="DISS_description/DISS_advisor[1]/DISS_name/DISS_fname"
						/>
					</xsl:variable>
					<xsl:variable name="lname">
						<xsl:value-of
							select="DISS_description/DISS_advisor[1]/DISS_name/DISS_surname"/>
					</xsl:variable>

					<xsl:variable name="mname">
						<xsl:value-of
							select="DISS_description/DISS_advisor[1]/DISS_name/DISS_middle"/>
					</xsl:variable>

							<xsl:value-of select="concat($lname,', ',$fname,' ', $mname)"/>
				</value>
			</field>

		</xsl:if>
		<xsl:if test="DISS_description/DISS_advisor[2]">
			<field name="alt_advisor2" type="string">
				<value>
					<xsl:variable name="fname">
						<xsl:value-of select="DISS_description/DISS_advisor[2]/DISS_name/DISS_fname"
						/>
					</xsl:variable>
					<xsl:variable name="lname">
						<xsl:value-of
							select="DISS_description/DISS_advisor[2]/DISS_name/DISS_surname"/>
					</xsl:variable>

					<xsl:variable name="mname">
						<xsl:value-of
							select="DISS_description/DISS_advisor[2]/DISS_name/DISS_middle"/>
					</xsl:variable>

							<xsl:value-of select="concat($lname,', ',$fname,' ', $mname)"/>
				</value>
			</field>

		</xsl:if>
				<xsl:if test="DISS_description/DISS_advisor[3]">
			<field name="alt_advisor3" type="string">
				<value>
					<xsl:variable name="fname">
						<xsl:value-of select="DISS_description/DISS_advisor[3]/DISS_name/DISS_fname"
						/>
					</xsl:variable>
					<xsl:variable name="lname">
						<xsl:value-of
							select="DISS_description/DISS_advisor[3]/DISS_name/DISS_surname"/>
					</xsl:variable>

					<xsl:variable name="mname">
						<xsl:value-of
							select="DISS_description/DISS_advisor[3]/DISS_name/DISS_middle"/>
					</xsl:variable>

							<xsl:value-of select="concat($lname,', ',$fname,' ', $mname)"/>
				</value>
			</field>

		</xsl:if>
			</xsl:template>
		<xsl:template match="DISS_description" name="advisor">
		<xsl:if test="DISS_description/DISS_advisor[1]">
			<field name="advisor1" type="string">
				<value>
					<xsl:variable name="fname">
						<xsl:value-of select="DISS_description/DISS_advisor[1]/DISS_name/DISS_fname"
						/>
					</xsl:variable>
					<xsl:variable name="lname">
						<xsl:value-of
							select="DISS_description/DISS_advisor[1]/DISS_name/DISS_surname"/>
					</xsl:variable>

					<xsl:variable name="mname">
						<xsl:value-of
							select="DISS_description/DISS_advisor[1]/DISS_name/DISS_middle"/>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$mname=''">
							<xsl:value-of select="concat($fname, ' ', $lname)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="minitial">
								<xsl:value-of select="substring($mname,1,1)"/>
							</xsl:variable>
							<xsl:value-of select="concat($fname,' ',$minitial, '. ',$lname)"/>
						</xsl:otherwise>
					</xsl:choose>
				</value>
			</field>

		</xsl:if>
		<xsl:if test="DISS_description/DISS_advisor[2]">
			<field name="advisor2" type="string">
				<value>
					<xsl:variable name="fname">
						<xsl:value-of select="DISS_description/DISS_advisor[2]/DISS_name/DISS_fname"
						/>
					</xsl:variable>
					<xsl:variable name="lname">
						<xsl:value-of
							select="DISS_description/DISS_advisor[2]/DISS_name/DISS_surname"/>
					</xsl:variable>

					<xsl:variable name="mname">
						<xsl:value-of
							select="DISS_description/DISS_advisor[2]/DISS_name/DISS_middle"/>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$mname=''">
							<xsl:value-of select="concat($fname, ' ', $lname)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="minitial">
								<xsl:value-of select="substring($mname,1,1)"/>
							</xsl:variable>
							<xsl:value-of select="concat($fname,' ',$minitial, '. ',$lname)"/>
						</xsl:otherwise>
					</xsl:choose>
				</value>
			</field>
		</xsl:if>
		<xsl:if test="DISS_description/DISS-advisor[3]">
			<field name="advisor3" type="string">
				<value>
					<xsl:variable name="fname">
						<xsl:value-of select="DISS_description/DISS_advisor[3]/DISS_name/DISS_fname"
						/>
					</xsl:variable>
					<xsl:variable name="lname">
						<xsl:value-of
							select="DISS_description/DISS_advisor[3]/DISS_name/DISS_surname"/>
					</xsl:variable>
					<xsl:variable name="mname">
						<xsl:value-of
							select="DISS_description/DISS_advisor[3]/DISS_name/DISS_middle"/>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$mname=''">
							<xsl:value-of select="concat($fname, ' ', $lname)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="minitial">
								<xsl:value-of select="substring($mname,1,1)"/>
							</xsl:variable>
							<xsl:value-of select="concat($fname,' ',$minitial, '. ',$lname)"/>
						</xsl:otherwise>
					</xsl:choose>
				</value>
			</field>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
