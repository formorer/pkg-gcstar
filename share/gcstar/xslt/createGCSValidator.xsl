<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : ConvertGCMtoXSD.xsl
    Created on : April 26, 2007, 9:41 PM
    Version    : The first one ;)
    Author     : toroman
    Description:
       Transforms GCM into XSD which can validate GCS files.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0">
        
    <xsl:output method="xml" indent="yes" />
    
    <xsl:template match="/">
        <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
            <xs:complexType name="itemType">
                <xs:sequence>
                    <xsl:apply-templates select="/collection/fields/field" />
                </xs:sequence>
            </xs:complexType>
            <xs:element name="collection">
                <xs:complexType>
                    <xs:sequence>
                        <xs:element name="information">
                            <xs:complexType>
                                <xs:sequence>
                                    <xs:element name="name" type="xs:string" />
                                </xs:sequence>
                            </xs:complexType>
                        </xs:element>
                        <xs:element name="item" maxOccurs="unbounded" type="itemType" />
                    </xs:sequence>
                    <xs:attribute name="type" type="xs:string" />
                    <xs:attribute name="items" type="xs:integer" />
                </xs:complexType>
            </xs:element>
        </xs:schema>
    </xsl:template>

    <xsl:template match="/collection/fields/field">
        <xsl:choose>
            <xsl:when test="@type='file'">
                <xsl:text disable-output-escaping="yes"><![CDATA[<xs:element name="]]></xsl:text>
                <xsl:value-of select="@value" /> 
                <xsl:text disable-output-escaping="yes"><![CDATA[" type="xs:string" />
                ]]></xsl:text>
            </xsl:when>
            <xsl:when test="@type='number'">
                <xsl:text disable-output-escaping="yes"><![CDATA[<xs:element name="]]></xsl:text>
                <xsl:value-of select="@value" /> 
                <xsl:text disable-output-escaping="yes"><![CDATA[" type="xs:integer" />
                ]]></xsl:text>
            </xsl:when>
            <xsl:when test="@type='options'">
                <xsl:text disable-output-escaping="yes"><![CDATA[<xs:element name="]]></xsl:text>
                <xsl:value-of select="@value" /> 
                <xsl:text disable-output-escaping="yes"><![CDATA[" type="xs:integer" />
                ]]></xsl:text>
            </xsl:when>
            <xsl:when test="@type='age'">
                <xsl:text disable-output-escaping="yes"><![CDATA[<xs:element name="]]></xsl:text>
                <xsl:value-of select="@value" /> 
                <xsl:text disable-output-escaping="yes"><![CDATA[" type="xs:integer" />
                ]]></xsl:text>
            </xsl:when>
            <xsl:when test="@type='short text'">
                <xsl:text disable-output-escaping="yes"><![CDATA[<xs:element name="]]></xsl:text>
                <xsl:value-of select="@value" /> 
                <xsl:text disable-output-escaping="yes"><![CDATA[" type="xs:string" />
                ]]></xsl:text>
            </xsl:when>
            <xsl:when test="@type='image'">
                <xsl:text disable-output-escaping="yes"><![CDATA[<xs:element name="]]></xsl:text>
                <xsl:value-of select="@value" /> 
                <xsl:text disable-output-escaping="yes"><![CDATA[" type="xs:string" />
                ]]></xsl:text>
            </xsl:when>
            <xsl:when test="@type='long text'">
                <xsl:text disable-output-escaping="yes"><![CDATA[<xs:element name="]]></xsl:text>
                <xsl:value-of select="@value" /> 
                <xsl:text disable-output-escaping="yes"><![CDATA[" type="xs:string" />
                ]]></xsl:text>
            </xsl:when>
            <xsl:when test="@type='button'">
                <xsl:text disable-output-escaping="yes"><![CDATA[<xs:element name="]]></xsl:text>
                <xsl:value-of select="@value" /> 
                <xsl:text disable-output-escaping="yes"><![CDATA[" type="xs:string" />
                ]]></xsl:text>
            </xsl:when>
            <xsl:when test="@type='yesno'">
                <xsl:text disable-output-escaping="yes"><![CDATA[<xs:element name="]]></xsl:text>
                <xsl:value-of select="@value" /> 
                <xsl:text disable-output-escaping="yes"><![CDATA[" type="xs:boolean" />
                ]]></xsl:text>
            </xsl:when>
            <xsl:when test="@type='date'">
                <xsl:text disable-output-escaping="yes"><![CDATA[
                <xs:element name="]]></xsl:text>
                    <xsl:value-of select="@value" /> 
                    <xsl:text disable-output-escaping="yes"><![CDATA[">
                    <xs:simpleType>
                        <xs:restriction base="xs:string">
                            <xs:pattern value="\d\d/\d\d/\d\d\d\d" />
                        </xs:restriction>
                    </xs:simpleType>
                </xs:element>
                ]]></xsl:text>
            </xsl:when>
            <xsl:when test="@type='single list'">
                <xsl:text disable-output-escaping="yes"><![CDATA[
                <xs:element name="]]></xsl:text>
                    <xsl:value-of select="@value" /> 
                    <xsl:text disable-output-escaping="yes"><![CDATA[">
                    <xs:complexType>
                        <xs:sequence maxOccurs="unbounded">
                            <xs:element name="line" maxOccurs="unbounded">
                                <xs:complexType>
                                    <xs:sequence minOccurs="1" maxOccurs="1">
                                        <xs:element name="col" type="xs:string" />
                                    </xs:sequence>
                                </xs:complexType>
                            </xs:element>
                        </xs:sequence>
                    </xs:complexType>
                </xs:element>
                ]]></xsl:text>
            </xsl:when>
            <xsl:when test="@type='double list'">
                <xsl:text disable-output-escaping="yes"><![CDATA[
                <xs:element name="]]></xsl:text>
                    <xsl:value-of select="@value" /> 
                    <xsl:text disable-output-escaping="yes"><![CDATA[">
                    <xs:complexType>
                        <xs:sequence maxOccurs="unbounded">
                            <xs:element name="line" maxOccurs="unbounded">
                                <xs:complexType>
                                    <xs:sequence minOccurs="2" maxOccurs="2">
                                        <xs:element name="col" type="xs:string" />
                                    </xs:sequence>
                                </xs:complexType>
                            </xs:element>
                        </xs:sequence>
                    </xs:complexType>
                </xs:element>
                ]]></xsl:text>
            </xsl:when>
            <xsl:when test="@type='history text'">
                <xsl:text disable-output-escaping="yes"><![CDATA[<xs:element name="]]></xsl:text>
                <xsl:value-of select="@value" /> 
                <xsl:text disable-output-escaping="yes"><![CDATA[" type="xs:string" />
                ]]></xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:text>Unknown Type - this should trigger error on XSD validation! </xsl:text> 
                    <xsl:value-of select="@type" />
                </p><![CDATA[
                ]]>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
