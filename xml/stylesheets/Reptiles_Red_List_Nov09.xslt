<?xml version="1.0" encoding="UTF-8"?>
<!--
      Clean redlist import for EUNIS
      Loads the European_reptiles_Red_List_Nov09_rev table
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
        <xsl:apply-templates select="Species"/>
        <xsl:apply-templates select="Notes"/>
        <xsl:apply-templates select="Europe_rl_category"/>
        <xsl:apply-templates select="EU_rl_category"/>
        <xsl:apply-templates select="rl_rationale"/>
        <xsl:apply-templates select="range"/>
        <xsl:apply-templates select="population"/>
        <xsl:apply-templates select="rl_trend"/>
        <xsl:apply-templates select="habitat"/>
        <xsl:apply-templates select="threats_info"/>
        <xsl:apply-templates select="cons_measures"/>
        <xsl:apply-templates select="Assessors"/>
    </Row>
  </xsl:template>


  <xsl:template match="Species">
    <xsl:element name="Scientific_name"><xsl:value-of select="../Genus"/><xsl:text> </xsl:text><xsl:value-of select="."/></xsl:element>
  </xsl:template>

  <xsl:template match="Europe_rl_category">
    <xsl:element name="Category">
      <xsl:attribute name="coverage">Europe</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="EU_rl_category">
    <xsl:element name="Category">
      <xsl:attribute name="coverage">EU25</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="rl_rationale">
    <xsl:element name="Rationale"><xsl:value-of select="."/></xsl:element>
  </xsl:template>
  
  <xsl:template match="range">
    <xsl:element name="Range"><xsl:value-of select="."/></xsl:element>
  </xsl:template>
  
  <xsl:template match="population">
    <xsl:element name="Population"><xsl:value-of select="."/></xsl:element>
  </xsl:template>
  
  <xsl:template match="rl_trend">
    <xsl:element name="Population_trend"><xsl:value-of select="."/></xsl:element>
  </xsl:template>
  
  <xsl:template match="habitat">
    <xsl:element name="Habitat"><xsl:value-of select="."/></xsl:element>
  </xsl:template>
  
  <xsl:template match="threats_info">
    <xsl:element name="Threats"><xsl:value-of select="."/></xsl:element>
  </xsl:template>

  <xsl:template match="cons_measures">
    <xsl:element name="Conservation_measures"><xsl:value-of select="."/></xsl:element>
  </xsl:template>

  


  <!-- Elements with no name change -->
  <xsl:template match="Kingdom|Phylum|Class|Order|Family|Notes|Assessors">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- elements that we ignore -->
  <xsl:template match="*"/>

</xsl:stylesheet>
