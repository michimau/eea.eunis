<?xml version="1.0" encoding="UTF-8"?>
<!--
      Clean redlist import for EUNIS
      Loads the European_Mammals_Red_List_Revised_data_Nov09 table
  -->
<xsl:stylesheet
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:od="urn:schemas-microsoft-com:officedata"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

  <xsl:template match="dataroot">
    <Red_List xsi:noNamespaceSchemaLocation="redlist.xsd">
       <xsl:apply-templates mode="row"/>
    </Red_List>
  </xsl:template>

  <!-- Row start -->
  <xsl:template match="*" mode="row">
    <Row>
        <xsl:apply-templates select="Kingdom"/>
        <xsl:apply-templates select="Phylum"/>
        <xsl:apply-templates select="Class"/>
        <xsl:apply-templates select="Order"/>
        <xsl:apply-templates select="Family"/>
        <xsl:apply-templates select="Genus_species"/>
        <xsl:apply-templates select="Taxonomic_x0020_Notes"/>
        <xsl:apply-templates select="Europe_x0020_Red_x0020_List_x0020_Category"/>
        <xsl:apply-templates select="EU25_x0020_Red_x0020_List_x0020_Category"/>
        <xsl:apply-templates select="Red_x0020_List_x0020_Rationale"/>
        <xsl:apply-templates select="Range"/>
        <xsl:apply-templates select="Population"/>
        <xsl:apply-templates select="Habitat"/>
        <xsl:apply-templates select="Threats"/>
        <xsl:apply-templates select="Conservation_Actions"/>
        <xsl:apply-templates select="RedListAssessors"/>
    </Row>
  </xsl:template>


  <xsl:template match="Genus_species">
    <xsl:element name="Scientific_name"><xsl:value-of select="."/></xsl:element>
  </xsl:template>
  
  <xsl:template match="Taxonomic_x0020_Notes">
    <xsl:element name="Notes"><xsl:value-of select="."/></xsl:element>
  </xsl:template>

  <xsl:template match="Europe_x0020_Red_x0020_List_x0020_Category">
    <xsl:element name="Category">
      <xsl:attribute name="coverage">Europe</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="EU25_x0020_Red_x0020_List_x0020_Category">
    <xsl:element name="Category">
      <xsl:attribute name="coverage">EU25</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Red_x0020_List_x0020_Rationale">
    <xsl:element name="Rationale"><xsl:value-of select="."/></xsl:element>
  </xsl:template>

  <xsl:template match="Conservation_Actions">
    <xsl:element name="Conservation_measures"><xsl:value-of select="."/></xsl:element>
  </xsl:template>

  <xsl:template match="Population_x0020_trend">
    <xsl:element name="Population_trend"><xsl:value-of select="."/></xsl:element>
  </xsl:template>

  <xsl:template match="RedListAssessors">
    <xsl:element name="Assessors"><xsl:value-of select="."/></xsl:element>
  </xsl:template>


  <!-- Elements with no name change -->
  <xsl:template match="Kingdom|Phylum|Class|Order|Family|Population|Habitat|Threats|Range">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- elements that we ignore -->
  <xsl:template match="*"/>

</xsl:stylesheet>
