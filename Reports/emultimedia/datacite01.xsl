<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:emu="http://kesoftware.com/emu">
<xsl:output omit-xml-declaration="yes" indent="yes"/>

<!-- 
	This XSLT report will generate an XML file 
	to prep a dataset for submission to repo's like DataCite
	 
	- Why not a direct 'XML' report from EMu?
		- Because currently EMu's native XML needs a lot of transformation. 
	
	- This currently works by reporting 1 record at a time.
-->

    <xsl:template match="/table/tuple">

	<xsl:variable name="creatorFull" select="table[@name='MulMultimediaCreatorRef_tab']/tuple/atom[@name='NamBriefName']" />
	<xsl:variable name="creatorFirst" select="table[@name='MulMultimediaCreatorRef_tab']/tuple/atom[@name='NamFirst']" />
	<xsl:variable name="creatorLast" select="table[@name='MulMultimediaCreatorRef_tab']/tuple/atom[@name='NamLast']" />
	<xsl:variable name="title" select="atom[@name='MulTitle']" />
	<xsl:variable name="publisher" select="tuple[@name='DetPublisherRef']/atom[@name='NamBriefName']" />
	<xsl:variable name="subjects" select="table[@name='DetSubject_tab']/tuble/atom[@name='DetSubject']" />
	<xsl:variable name="publicationYear" select="atom[@name='AdmDateModified']" />
	<xsl:variable name="date" select="table[@name='Dates']/tuple/atom[@name='DetResourceDetailsDate']" />
	<xsl:variable name="dateType" select="table[@name='Dates']/tuple/atom[@name='DetResourceDetailsDescription']" />
	<xsl:variable name="language" select="table[@name='DetLanguage_tab']/tuple/atom[@name='DetLanguage']" />
	<xsl:variable name="resourceType" select="atom[@name='DetResourceType']" />
	<xsl:variable name="alternateIdentifier" select="table[@name='alternateIdentifiers']/tuple/atom[@name='AdmGUIDValue']" />
	<xsl:variable name="alternateIdentifierType" select="table[@name='alternateIdentifiers']/tuple/atom[@name='AdmGUIDType']" />
	<xsl:variable name="format" select="atom[@name='MulMimeFormat']" />
	<xsl:variable name="supformat" select="table[@name='SupMimeFormat_tab']/tuple/atom[@name='SupMimeFormat']"/>
	<xsl:variable name="version" select="atom[@name='AdmDateModified']" />
	<xsl:variable name="rights" select="tuple[@name='DetMediaRightsRef']/atom[@name='RigOtherNumber']" />
	<xsl:variable name="description" select="atom[@name='MulDescription']" />

<resource xmlns="http://datacite.org/schema/kernel-4" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd">
<identifier identifierType="DOI">
  <xsl:for-each select="/table/tuple/table[@name='alternateIdentifiers']/tuple">
	<xsl:if test="atom[@name='AdmGUIDType'] = 'DOI'">
		<xsl:value-of select="atom[@name='AdmGUIDValue']"/>
	</xsl:if>
  </xsl:for-each>
  </identifier>
  <creators>
	<xsl:for-each select="/table/tuple/table[@name='MulMultimediaCreatorRef_tab']/tuple">
    <creator>
		<creatorName><xsl:value-of select="$creatorFull"/></creatorName>
			<givenName><xsl:value-of select="$creatorFirst"/></givenName>
			<familyName><xsl:value-of select="$creatorLast"/></familyName>
    </creator>
	</xsl:for-each>
  </creators>
  <titles>
    <title><xsl:value-of select="$title"/></title>
  </titles>
  <publisher><xsl:value-of select="$publisher"/></publisher>
  <publicationYear><xsl:value-of select="$publicationYear"/></publicationYear>
  <subjects>
    <xsl:for-each select="/table/tuple/table[@name='DetSubject_tab']/tuple">
		<xsl:if test="atom[@name='DetSubject'] != ''">
			<subject subjectScheme="User Contributed Keyword"><xsl:value-of select="atom[@name='DetSubject']"/>
			</subject>
		</xsl:if>
	</xsl:for-each>
  </subjects>
  <dates>
	<xsl:for-each select="/table/tuple/table[@name='Dates']/tuple">
    <date dateType="Created"> 
		<xsl:if test="$dateType = 'Created'">
			<xsl:value-of select="$date"/>
		</xsl:if>
	</date>
	<date dateType="Available"> 
		<xsl:if test="$dateType != 'Created'">
			<xsl:value-of select="$date"/>
		</xsl:if>
	</date>
	</xsl:for-each>
  </dates>
  <language>
	<xsl:for-each select="/table/tuple/table[@name='DetLanguage_tab']/tuple">
		<xsl:value-of select="$language"/>
	</xsl:for-each>
  </language>
  <resourceType resourceTypeGeneral="Dataset"><xsl:value-of select="$resourceType"/></resourceType>
  <alternateIdentifiers>
	<xsl:for-each select="/table/tuple/table[@name='alternateIdentifiers']/tuple">
	    <alternateIdentifier alternateIdentifierType="URL">
		<!--xsl:choose-->
			<xsl:if test="atom[@name='AdmGUIDType'] = 'UUID4'">
				https://mm.fieldmuseum.org/<xsl:value-of select="atom[@name='AdmGUIDValue']"/>
			</xsl:if>
            <xsl:if test="atom[@name='AdmGUIDType'] != 'UUID4'">
				https://n2t.net/<xsl:value-of select="atom[@name='AdmGUIDValue']"/>
			</xsl:if>
		<!--/xsl:choose-->
		</alternateIdentifier>
	</xsl:for-each>
  </alternateIdentifiers>
 
  <relatedIdentifiers>
    <relatedIdentifier relatedIdentifierType="URL" relationType="References"></relatedIdentifier>
  </relatedIdentifiers>
  <formats>
    <format><xsl:value-of select="$format"/></format>
	<xsl:for-each select="/table/tuple/table[@name='SupMimeFormat_tab']/tuple">
		<format><xsl:value-of select="atom[@name='SupMimeFormat']"/></format>
	</xsl:for-each>
  </formats>
  <version>1.0</version>
  <rightsList>
    <rights rightsURI="https://creativecommons.org/licenses/by-nc/4.0/us/"><xsl:value-of select="$rights"/></rights>
  </rightsList>
  <descriptions>
    <description descriptionType="Abstract"><xsl:value-of select="$description"/></description>
    <description descriptionType="Other"></description>
  </descriptions>
</resource>

</xsl:template>

</xsl:stylesheet>