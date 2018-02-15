<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- Copyright 2009 Shawn Averkamp and Joanna Lee
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
	
	<xsl:output method="text" version="1.0" encoding="UTF-8"/>
	<!-- Transform of bepress XML to a tab-delimited file for Electronic Theses and Dissertations (ETDs) -->
	
	<xsl:template match="/">
		<!-- Header row -->
		<xsl:text>Title&#9;Author&#9;Advisor1&#9;Advisor2&#9;Advisor3&#9;Type&#9;Degree Name&#9;Embargo&#9;Department&#9;Discipline&#9;Date&#9;Language&#9;TPages&#9;Keywords&#9;Abstract&#9;URL&#9;filename&#xa;</xsl:text>
		
		<xsl:for-each select="documents/document">
			<xsl:value-of select="normalize-space(title)"/>
			<xsl:text>&#9;</xsl:text>
			<!-- Function to pull author name together in one field, separated by spaces -->
			<xsl:variable name="lname" select="authors/author/lname"/>
			<xsl:variable name="fname" select="authors/author/fname"/>
			<xsl:variable name="mname" select="authors/author/mname"/>
			<xsl:variable name="suffix" select="authors/author/suffix"/>
			<xsl:value-of select="concat($lname,', ', $fname,' ',$mname, ', ',$suffix)"/>
			<xsl:text>&#9;</xsl:text>
			<xsl:value-of select="fields/field[@name='advisor1']/value"/>
			<xsl:text>&#9;</xsl:text>
			<xsl:value-of select="fields/field[@name='advisor2']/value"/>
			<xsl:text>&#9;</xsl:text>
			<xsl:value-of select="fields/field[@name='advisor3']/value"/>
			<xsl:text>&#9;</xsl:text>
			<xsl:value-of select="document-type"/>
			<xsl:text>&#9;</xsl:text>
			<xsl:value-of select="degree_name"/>
			<xsl:text>&#9;</xsl:text>
			<xsl:value-of select="fields/field[@name='embargo_date']/value"/>
			<xsl:text>&#9;</xsl:text>
			<xsl:value-of select="department"/>
			<xsl:text>&#9;</xsl:text>
			<xsl:value-of select="disciplines/discipline"/>
			<xsl:text>&#9;</xsl:text>
			<xsl:value-of select="publication-date"/>
			<xsl:text>&#9;</xsl:text>
			<xsl:value-of select="fields/field[@name='language']/value"/>
			<xsl:text>&#9;</xsl:text>
			<xsl:value-of select="fields/field[@name='tpages']/value"/>
			<xsl:text>&#9;</xsl:text>
			<!-- Combine keywords into one field separated by commas -->
			<xsl:for-each select="keywords/keyword">
				<xsl:value-of select="normalize-space(.)"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>&#9;</xsl:text>
			<!-- Combine abstract into one field separated by <p> tags -->
			<xsl:for-each select="abstract/p">
				<xsl:text>&lt;p&gt;</xsl:text>
				<xsl:value-of select="normalize-space(.)"/>
				<xsl:text>&lt;/p&gt;</xsl:text>
			</xsl:for-each>
			<xsl:text>&#9;</xsl:text>
			<!-- Function to predict URL of ETD in bepress based on the label that was force-generated during the transformation from ProQuest XML to bepress XML -->
			<xsl:variable name="labelvalue" select="label"></xsl:variable>
			<xsl:value-of select="concat('http://ir.uiowa.edu/etd/', $labelvalue)"/>
						<xsl:text>&#9;</xsl:text>
			<xsl:value-of select="fulltext-url"/>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
