<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:emu="http://kesoftware.com/emu">
    <xsl:output method="html" encoding="ISO-8859-1"/>

    <xsl:template match="/table/tuple">
        <!--Variables for all the data from the report. Add a variable for each field from the report
        Having the values separated out into variables here makes the logic easier to understand-->

		<xsl:variable name="inventoryno" select="atom[@name='StaEventCatalogueNumber']" />
 		<xsl:variable name="status" select="atom[@name='StaStatus']" />
		<xsl:variable name="dayone" select="atom[@name='StaDayOne']" />
		<xsl:variable name="devdisplaynotes" select="atom[@name='DevDisplayNotes']" />
		<xsl:variable name="section" select="atom[@name='StaSectionTitle']" />
		<xsl:variable name="sectionno" select="atom[@name='StaSectionNumber']" />
		<xsl:variable name="group" select="atom[@name='DevGroup']" />
		<xsl:variable name="subgroup" select="atom[@name='DevSubGroup']" />
		<xsl:variable name="case" select="atom[@name='StaCaseWall']" />
		<xsl:variable name="buttonno" select="atom[@name='DevButtonNumber']" />
		<xsl:variable name="mntdisplay" select="atom[@name='MouDisplay']" />
		<xsl:variable name="mntangle" select="atom[@name='MouAngle']" />
		<xsl:variable name="mntsurface" select="atom[@name='MouSurface']" />
		<xsl:variable name="mountnotes" select="atom[@name='MouMountNotes']" />
		<xsl:variable name="mountcasenotes" select="atom[@name='MouCaseNotes']" />
		<xsl:variable name="mountdetails" select="atom[@name='MouMountDetails']" />
		<xsl:variable name="targetrh" select="atom[@name='EnvTargetRelativeHumidity']" />
		<xsl:variable name="pmtarget" select="atom[@name='EnvRelativeHumidityModifier']" />	
		<xsl:variable name="maxfootcandles" select="atom[@name='EnvMaxIlluminationLevel']" />
		<xsl:variable name="casereq" select="table[@name='EnvCaseRequirement_tab']/tuple/atom[@name='EnvCaseRequirement']" />
		<xsl:variable name="consnotes" select="atom[@name='EnvNotes']" />
        <xsl:variable name="setpointrange" select="atom[@name='EnvSetPointRange']" />
                
		<!--may need to replace this?-->
		<!-- xsl:variable name="objectname" select="tuple[@name='StaObjectRef']" / -->
        <xsl:variable name="objectname" select="atom[@name='OveExhibitionObjectName']" />

		<!--INSTALLATION multimedia (the first image)-->
        <xsl:variable name="insmedia" select="table[@name='InsMultimediaRef_tab']/tuple/atom[@name='Multimedia']" />
		<xsl:variable name="inskind" select="table[@name='InsKind_tab']/tuple/atom[@name='InsKind']" />
		
		<!--multimedia (the first image)-->
        <xsl:variable name="multimediakey" select="table[@name='MulMultiMediaRef_tab']/tuple[1]/atom[@name='Multimedia']" />
		<xsl:variable name="multimediaside" select="table[@name='MulMultiMediaRef_tab']/tuple[3]/atom[@name='Multimedia']" />
        <xsl:variable name="mulidentifier" select="table[@name='MulMultiMediaRef_tab']/tuple/table[@name='DocIdentifier_tab']/tuple[1]/atom[@name='DocIdentifier']" />

		<!-- measurements -->
		<xsl:variable name="meakind" select="table[@name='MeaMeasurementKind_tab']/tuple/atom[@name='MeaMeasurementKind']" />
        <xsl:variable name="meataken" select="table[@name='MeaMeasurementTaken_tab']/tuple/atom[@name='MeaMeasurementTaken']" />		
		<xsl:variable name="meavalue" select="table[@name='MeaMeasurementFraction_tab']/tuple/atom[@name='MeaMeasurementFraction']" />
		<xsl:variable name="mearemarks" select="table[@name='MeaRemarks_tab']/tuple/atom[@name='MeaRemarks']" />
<!-->		<xsl:variable name="meaconfirmed" select="table[@name='MeaMeasurementConfirmed_tab']/tuple/atom[.='Yes']" /> -->
        <xsl:variable name="meaconfirmed" select="table[@name='MeaMeasurementConfirmed_tab']/tuple/atom[@name='MeaMeasurementConfirmed']" /> 
        <xsl:variable name="meadate" select="table[@name='MeaStartDate0']/tuple/atom[@name='MeaStartDate']" />
        <xsl:variable name="meaby" select="table[@name='MeaMeasuredByRef_tab']/tuple/atom[@name='NamBriefName']" />

        <html>
            <head>
                <xsl:call-template name="styles"/>
                <xsl:call-template name="scripts"/>
            </head>
            <body class="sheet" onLoad="loaded()">

                    <!-- <div id="header"> -->

                    <table>
					
						<tr>
                           <td class="prompt">Inv No</td>
                           <td class="left" width="700px">
                               <xsl:value-of select="$inventoryno" />
                           </td>
                       </tr>
                       <tr>
                           <td class="prompt">Object Name</td>
                           <td class="left" width="700px">
                               <xsl:value-of select="$objectname" />
                           </td>
					   </tr>
						<tr>
                           <td class="prompt">Status</td>
                           <td class="left" width="700px">
                               <xsl:value-of select="$status" />
                           </td>
                       </tr>
                       <tr>
                           <td class="prompt">Day One</td>
                           <td class="left" width="700px">
                               <xsl:value-of select="$dayone" />
                           </td>
					   </tr>

					</table>

<p/>

					<!-- </div> -->
<p>				
<!--                    <div id="images"> -->
						<!-- this grabs all the images attached to the Exh. object -->
                        <table >
                           <tr height="115px">
						   <xsl:choose>
							<xsl:when test = "count(table[@name='InsMultimediaRef_tab']/tuple)>0">
						    <xsl:for-each select="table[@name='InsMultimediaRef_tab']/tuple">
							<xsl:choose>
							    <xsl:when test="count(atom[@name='Multimedia'])=0">
								<td class="value" width="120px" vertical-align="bottom">No Image</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="value" width="125px">
									<img class="multimediaimage" height="90px" width="120px">
									<xsl:attribute name="src" >
									<xsl:value-of select="concat('file:///', translate(atom[@name='Multimedia'], '\', '/'))" />
									</xsl:attribute>
									</img>
									</td>
								</xsl:otherwise>
							</xsl:choose>
							</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
						   <xsl:if test="count(table[@name='MulMultiMediaRef_tab']/tuple)=0">
						   <td class="value" width="120px" vertical-align="bottom">No Images</td></xsl:if>
                           <xsl:for-each select="table[@name='MulMultiMediaRef_tab']/tuple">
                           <td class="value" width="125px">
                           <img class="multimediaimage" height="90px" width="120px">
                                <xsl:attribute name="src" >
									<xsl:value-of select="concat('file:///', translate(atom[@name='Multimedia'], '\', '/'))" />
                                </xsl:attribute>
                            </img>
                            </td>  
                        </xsl:for-each>
						</xsl:otherwise>
						</xsl:choose>
						</tr>
	
	
                        <tr height="30px">
						<xsl:choose>
							<xsl:when test="count(table[@name='InsMultimediaRef_tab']/tuple)>0">
							<xsl:for-each select="table[@name='InsKind_tab']/tuple">
								<td class="tvalue">
								<p font="smaller"><xsl:value-of select="atom[@name='InsKind']" /></p>
								</td>
							</xsl:for-each>
							</xsl:when>
                           <xsl:otherwise>
                        <xsl:if test="count(table[@name='MulMultiMediaRef_tab']/tuple/table[@name='DocIdentifier_tab']/tuple[1])=0"><td class="value" width="120px"><p font="smaller">-</p></td></xsl:if>
					    <xsl:for-each select="table[@name='MulMultiMediaRef_tab']/tuple/table[@name='DocIdentifier_tab']/tuple[1]">
                           <td class="tvalue">
                           <p font="smaller"><xsl:value-of select="atom[@name='DocIdentifier']" /></p>
                           </td>
                           </xsl:for-each>
						</xsl:otherwise>
						</xsl:choose>
                        </tr>

                        </table>
                        </p>
						<!-- ...But need to arrange them by key/side/etc, possible like so:
                        <xsl:if test="$multimediakey != ''">
                            <img class="multimediaimage">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="concat('file:///', translate($multimediakey, '\', '/'))" /> 
                                </xsl:attribute>
                            </img>
                        </xsl:if>
						<xsl:if test="contains(table[@name='MulMultiMediaRef_tab']/tuple[1-4]/atom[@name='Multimedia'], '')"> 
                            <img class="multimediaimage">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="concat('file:///', translate($multimediaside, '\', '/'))" /> 
                                </xsl:attribute>
                            </img>
                        </xsl:if> -->
					<!--</div> -->

					
                   <div id="data">
                       <p>
                       <table border="0"  bgcolor="#cedfdf" width="1100px">
					   <tr bgcolor="#cedfdf">
                           <td class="title" width="290px">Section</td>
                           <td class="title" width="400px">Group</td>
						   <td class="title" width="300px">Sub-group</td>
                           <td class="title" width="50px">Case</td>
                           <td class="title" width="60px">Button #</td>						   
					   </tr>

                       <tr bgcolor="#e6eeee">		   
							<td class="tvalue"><xsl:if test="$section = ''">-</xsl:if><xsl:value-of select="$section"/></td>
							<td class="tvalue"><xsl:if test="$group = ''">-</xsl:if><xsl:value-of select="$group"/></td>
							<td class="tvalue"><xsl:if test="$subgroup = ''">-</xsl:if><xsl:value-of select="$subgroup"/></td>
                            <td class="tvalue"><xsl:if test="$case = ''">-</xsl:if><xsl:value-of select="$case"/></td>
                            <td class="tvalue"><xsl:if test="$buttonno = ''">-</xsl:if><xsl:value-of select="$buttonno"/></td>
						</tr>
						</table>
                        </p>

                       <p>
                       <table border="0"  bgcolor="#cedfdf" width="1100px">
					   <tr bgcolor="#cedfdf">
                           <td class="title" width="140px">Dev. Display Notes</td>
							<td class="lvalue" bgcolor="#e6eeee"><xsl:value-of select="$devdisplaynotes"/></td>
                            </tr>
                       </table>
                       </p>
                        
					   <p class="nest">
                       <table border="0">
                       <tr class="nest"><td class="nest">
					   <table bgcolor="#cedfdf"  width="750px">
						   <tr bgcolor="#cedfdf"><td class="mou" width="100px">Mount Display</td><td class="left" width="650px" bgcolor="#e6eeee"><xsl:value-of select="$mntdisplay" /></td></tr>
						   <tr bgcolor="#cedfdf"><td class="mou" width="100px">Angle</td><td class="left" width="650px" bgcolor="#e6eeee"><xsl:value-of select="$mntangle" /></td></tr>
						   <tr bgcolor="#cedfdf"><td class="mou" width="100px">Surface</td><td class="left" width="650px" bgcolor="#e6eeee"><xsl:value-of select="$mntsurface" /></td></tr>
						   <tr bgcolor="#cedfdf"><td class="mou" width="100px">Notes</td><td class="left" width="650px" bgcolor="#e6eeee"><xsl:value-of select="$mountnotes" /></td></tr>
						   <tr bgcolor="#cedfdf"><td class="mou" width="100px" height="36px">Case Notes</td><td class="left" width="650px" bgcolor="#e6eeee"><xsl:value-of select="$mountcasenotes" /></td></tr>
						   <tr bgcolor="#cedfdf"><td class="mou" width="100px">Mount Details</td><td class="left" width="650px" bgcolor="#e6eeee"><xsl:value-of select="$mountdetails" /></td></tr>
                           <tr bgcolor="#cedfdf"><td class="mou" width="100px" height="36px">Cons. Notes</td><td class="left" width="650px" bgcolor="#e6eeee"><xsl:value-of select="$consnotes" /></td></tr>
						</table>
                        </td>
                        
					   <td>
						<table border="0" bgcolor="#cedfdf" width="175px">
							<tr class="last">
								<td class="mou" width="50px">Target RH</td>
								<td class="tvalue" width="125px" bgcolor="#e6eeee">
									<xsl:value-of select="($targetrh)-($pmtarget)" /> - <xsl:value-of select="($targetrh)+($pmtarget)" />
								</td>
                            </tr>
                            <tr>
								<td class="mou" width="50px">Max FC</td>
								<td class="tvalue" width="125px" bgcolor="#e6eeee">
									<xsl:value-of select="$maxfootcandles" />
								</td>
							</tr>
						</table>
						<table border="0" bgcolor="#cedfdf" width="175px">
							<tr class="last">
								<!--table border="0" width="200px"-->
								<td class="mou" >Case Req</td>
								<td class="tvalue" width="125px" bgcolor="#cedfdf">
									<td class="mou" width="115px"><table><xsl:for-each select="table[@name='EnvCaseRequirement_tab']/tuple"><tr class="value"><td class="value" width="80px"><xsl:if test="atom[@name='EnvCaseRequirement'] = ''">-</xsl:if><xsl:value-of select="atom[@name='EnvCaseRequirement']"/></td></tr></xsl:for-each></table></td>
									<td class="mou" bgcolor="#e6eeee"><table><xsl:for-each select="table[@name='EnvCaseRequirementYesNo_tab']/tuple"><tr class="value"><td class="value" width="80px"><xsl:if test="atom[@name='EnvCaseRequirementYesNo'] = ''">-</xsl:if><xsl:value-of select="atom[@name='EnvCaseRequirementYesNo']"/></td></tr></xsl:for-each></table></td>
								</td>
								<!--/table-->
							</tr>
						</table>
					   </td></tr></table>
                       </p>
                       
                       <p>
					   <table border="0" bgcolor="#cedfdf" width="1210px">
					   <tr bgcolor="#cedfdf" class="nest">
							<td class="title" width="115px">Meas. Taken</td>
							<td class="title" width="70px">Kind</td>
							<td class="title" width="70px">Value</td>
							<td class="title" width="70px">Weight</td>
							<td class="title" width="440px">Remarks</td>
							<td class="title" width="90px">Confirmed</td>
                            <td class="title" width="310px">Meas. By</td>
                            <td class="title" width="95px">Date</td>
						</tr>
                        
                      <!-- for-each here, loop through each whole row to confirm  -->
                      <!-- <xsl:if test="contains(tuple/atom[@name='MeaMeasurementConfirmed'], 'confirmed')"> -->
                      <tr bgcolor="#e6eeee" class="nest">
                           <td class="value">
							<table>
								<xsl:for-each select="table[@name='MeaMeasurementTaken_tab']/tuple">
									<tr class="value">
									<td class="value" width="115px">
										<xsl:if test="atom[@name='MeaMeasurementTaken'] = ''">-</xsl:if>
										<xsl:value-of select="atom[@name='MeaMeasurementTaken']"/>
									</td>
									</tr>
								</xsl:for-each>
							</table>
						   </td>
                           <td class="value"><table><xsl:for-each select="table[@name='MeaMeasurementKind_tab']/tuple"><tr class="value"><td class="value" width="70px"><xsl:if test="atom[@name='MeaMeasurementKind'] = ''">-</xsl:if><xsl:value-of select="atom[@name='MeaMeasurementKind']"/></td></tr></xsl:for-each></table></td>
                           <td class="value"><table><xsl:for-each select="table[@name='MeaMeasurmentFraction_tab']/tuple"><tr class="value"><td class="value" width="70px"><xsl:if test="atom[@name='MeaMeasurmentFraction'] = ''">-</xsl:if><xsl:value-of select="atom[@name='MeaMeasurmentFraction']"/></td></tr></xsl:for-each></table></td>
						   <td class="value"><table><xsl:for-each select="table[@name='MeaWeightImp_tab']/tuple"><tr class="value"><td class="value" width="70px"><xsl:if test="atom[@name='MeaWeightImp'] = ''">-</xsl:if><xsl:value-of select="atom[@name='MeaWeightImp']"/></td></tr></xsl:for-each></table></td>
                           <td class="value"><table><xsl:for-each select="table[@name='MeaRemarks_tab']/tuple"><tr class="value"><td class="value" width="440px"><xsl:if test="atom[@name='MeaRemarks'] = ''">-</xsl:if><xsl:value-of select="atom[@name='MeaRemarks']"/></td></tr></xsl:for-each></table></td>
						   <td class="value"><table><xsl:for-each select="table[@name='MeaMeasurementConfirmed_tab']/tuple"><tr class="value"><td class="value" width="90px"><xsl:if test="atom[@name='MeaMeasurementConfirmed'] = ''">-</xsl:if><xsl:value-of select="atom[@name='MeaMeasurementConfirmed']"/></td></tr></xsl:for-each></table></td>
                           <td class="value"><table><xsl:for-each select="table[@name='MeaMeasuredByRef_tab']/tuple"><tr class="value"><td class="mvalue" width="310px" style="white-space:nowrap"><xsl:if test="count(atom[@name='NamBriefName'])=0">-</xsl:if><xsl:value-of select="atom[@name='NamBriefName']"/><xsl:if test=". = ''">" "</xsl:if></td></tr></xsl:for-each></table></td>
                           <td class="value"><table><xsl:for-each select="table[@name='MeaStartDate0']/tuple"><tr class="value"><td class="value" width="95px"><xsl:if test="atom[@name='MeaStartDate'] = ''">-</xsl:if><xsl:value-of select="atom[@name='MeaStartDate']"/></td></tr></xsl:for-each></table></td>
                       </tr>
                       <!-- </xsl:if> -->
                      

					   </table>
                       </p>

					   <!--
                       <tr>
                           <td class="prompt">Collection Date</td>
                           <td class="value">
                               <xsl:choose>
                                   <xsl:when test="$date_collected!=''">
                                       <xsl:value-of select="$date_collected"/>
                                   </xsl:when>
                                   <xsl:when test="$date_from!='' and $date_to!='' and $date_from!=$date_to">
                                       <xsl:value-of select="concat($date_from,'-',$date_to)"/>
                                   </xsl:when>
                                   <xsl:otherwise>
                                       <xsl:value-of select="$date_from"/>
                                   </xsl:otherwise>
                               </xsl:choose>
                           </td>
                       </tr>
					   -->

                    </div>
                    
                
                    <div id="footer">
                        <xsl:value-of select="atom[@name = 'irn']"/>
                    </div>
                    					
			</body>
		</html>
	</xsl:template>


	<!--
           CSS styles template
     -->
    <xsl:template name="styles">
        <style type="text/css">
            <xsl:text>
#images {
        padding-top: 0em;
        padding-bottom: 0em;
        padding-left: 0em;
        padding-right: 0em;
        overflow:hidden;
        margin: 0em;
		
        }  
.multimediaimage{
	float: center;
    vertical-align: center;
    height:100px;
    max-width:100px;
    border-width: 0px;
    border-style: solid;
    border-color: #c41230;
    margin: 0.1em;
}

body.sheet
{
    font-family: Arial;
    background-color: #dae7e7;
}
table.sheet
{
    width: 90%;
    border-width: 1px;
    border-style: solid;
    border-collapse: collapse;
    background-color: #EEEEEE;
    border-color: #0E6CA5;
}

#header
{
	width:20%;
	float:left;
    background-color: #0e7e7e;
    color: #FFFFFF;
    font-weight: bold;
    padding-top: 0.5em;
    padding-bottom: 0.5em;
    padding-left: 0.5em;
    padding-right: 0.5em;
}
table.picture
{
    width: 20%;
}
table.icon
{
    border-width: 0px;
    border-style: solid;
    border-color: #c41230;
	padding-top: 0.1em;
    padding-bottom: 0.1em;
    padding-left: 0.1em;
    padding-right: 0.1em;
}

td.icon
{
    width: 0px;
}

top{
	float:left;
	font-weight: bold;
	width: 100px;
    padding-top: 0.5em;
    padding-bottom: 0.5em;
    padding-left: 0.5em;
    padding-right: 0.5em;
}

td.mou, td
{
    font-weight: bold;
    font-size: smaller;
	text-align: right;
    vertical-align: top;
    padding-left: 0.1em;
    padding-right: 0.1em;	
}

table.nest
{
    border-width: 0px;
	padding-top: 0em;
    padding-bottom: 0em;
    padding-left: 0em;
    padding-right: 0em;
}

tr.nest, td.nest
{
    padding-left: 0em;
    padding-right: 0em;	
}

p.nest
{
    padding-left: 0.4em;
    padding-right: 0em;
}

tr.values
{
	text-align: center;
	vertical-align: center;
    padding-left: 0.2em;
    padding-right: 0.2em;	
}

tr.last
{
    width: 90%;
	text-align: center;
	vertical-align: top;
    padding-left: 0.5em;
    padding-right: 0.5em;	
}

table.data
{
    width: 90%;
    border-width: 1px;
}
td.title
{
    font-weight: bold;
    font-size: smaller;
    text-align: center;
	vertical-align: center;
    padding-top: 0.5em;
    padding-bottom: 0.5em;
    padding-left: 0.2em;
    padding-right: 0.2em;
}
td.meas
{
    width: 100px;
    font-weight: bold;
    font-size: smaller;
    text-align: left;
	vertical-align: center;
    padding-top: 0.2em;
    padding-bottom: 0.2em;
}

p
{
    font-weight: bold;
    font-size: smaller;
    vertical-align: bottom;
    padding-left: 0.5em;
    padding-right: 0.5em;
}

td.prompt, th
{
    width: 110px;
    font-weight: bold;
    font-size: smaller;
	text-align: right;
    vertical-align: center;
    padding-left: 0.2em;
    padding-right: 0.7em;
}
td.left
{
    text-align: left;
	vertical-align: top;
    font-weight: normal;
    font-size: smaller;
    padding-left: 0.5em;
    padding-right: 0.5em;
}
td.value
{
    text-align: center;
	vertical-align: top;
    font-weight: normal;
    font-size: xx-small;
    padding-left: 0.2em;
    padding-right: 0.2em;
}
td.tvalue
{
    text-align: center;
	vertical-align: top;
    font-weight: normal;
    font-size: smaller;
    padding-left: 0.2em;
    padding-right: 0.2em;
}

td.lvalue
{
    text-align: left;
	vertical-align: middle;
    font-weight: normal;
    font-size: smaller;
    padding-left: 0.2em;
    padding-right: 0.2em;
}
td.mvalue
{
    position: relative;
    max-width: 130px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    text-align: center;
	vertical-align: top;
    font-weight: normal;
    font-size: xx-small;
    padding-left: 0.2em;
    padding-right: 0.2em;
}

</xsl:text>
        </style>
    </xsl:template>
    <!--
            Scripts template
     -->
    <xsl:template name="scripts">
        <script type="text/javascript">
        <xsl:text>
        function loaded()
        {
            var tables = document.getElementsByTagName("table");

            for (var index = 0; index &lt; tables.length; index++)
            {
                if (tables[index].id == "datatable")
                    for (var row = 0; row &lt; tables[index].rows.length; row++)
                        if (row % 2 == 0)
                            tables[index].rows[row].bgColor = "#FFFFFF";
            }
        }
        </xsl:text>
        </script>
    </xsl:template>

	
</xsl:stylesheet>