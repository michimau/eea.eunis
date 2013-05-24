<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
                <!-- species status -->
                <h2>How is this species doing?</h2>

                <div class="left-area">
                    <div class="threat-status-indicator width-12">
                        <h3>International threat status</h3>
                        <div class="threat-status-un roundedCorners">

                            <div class="text-right">
                                <p class="threat-status-region x-small-text">World</p>
                                <p class="threat-status-label small-text">Unknown</p>
                                <!-- Tooltip example using eea-flexible-tooltip classes -->
                                <p class="threat-status-source small-text eea-flexible-tooltip-right" title="Unknown threat level for the world">
                                    <img src="icon-questionmark.png"/></p>
                            </div>

                            <div class="threat-status-vu roundedCorners width-11">
                                <div class="text-right">
                                    <p class="threat-status-region x-small-text">Europe</p>
                                    <p class="threat-status-label small-text eea-flexible-tooltip-right" title="A Vulnerable species is one which has been categorized by the International Union for Conservation of Nature (IUCN) as likely to become Endangered unless the circumstances threatening its survival and reproduction improve">Vulnerable</p>
                                    <p class="threat-status-source"><a href="http://eunis.eea.europa.eu/references/2341">(IUCN, 2009)</a></p>
                                </div>

                                <div class="threat-status-cr roundedCorners width-9">
                                    <div class="text-right">
                                        <p class="threat-status-region x-small-text">EU</p>
                                        <p class="threat-status-label small-text eea-flexible-tooltip-right" title="Critically Endangered is the highest risk category assigned by the IUCN Red List for wild species. Critically Endangered species are those that are facing a very high risk of extinction in the wild">Critically endangered</p>
                                        <p class="threat-status-source"><a href="http://eunis.eea.europa.eu/references/2341">(IUCN, 2009)</a></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="footer">
                        <!-- Table definition dropdown example -->
                        <div class="table-definition contain-float">
                            <div class="width-12 contain-float">
                                <span class="table-definition-target standardButton float-left">
                                   See full table details
                                </span>
                                <a href="#threat-status-overlay" rel="#threat-status-overlay" class="float-right">Other resources</a>
                            </div>
                            <div class="table-definition-body">
                                <table summary="International Threat Status" class="listing fullwidth">
                                    <colgroup><col style="width: 20%">
                                        <col style="width: 20%">
                                        <col style="width: 20%">
                                        <col style="width: 40%">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                                            Area

                                            <img src="http://www.eea.europa.eu/arrowUp.gif" height="6" width="9"></th>
                                        <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                                            Status

                                            <img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9"></th>
                                        <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                                            International threat code

                                            <img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9"></th>
                                        <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                                            Reference

                                            <img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9"></th>
                                    </tr>
                                    </thead>
                                    <tbody>

                                    <tr>
                                        <td>
                                            World
                                        </td>
                                        <td>
                                            Endangered
                                        </td>
                                        <td>
                                                   <span class="boldUnderline" title="ENDANGERED : A taxon is Endangered when it is not Critically Endangered but is facing a very high risk of extinction in the wild in the near future">
                                                   EN
                                                   </span>
                                        </td>
                                        <td>
                                            <a href="references/1787">IUCN (2000)</a>
                                        </td>
                                    </tr>

                                    <tr class="zebraeven">
                                        <td>
                                            World
                                        </td>
                                        <td>
                                            Critically endangered
                                        </td>
                                        <td>
                                            <span class="boldUnderline" title="CRITICALLY ENDANGERED : A taxon is Critically Endangered when it is facing an extremely high risk of extinction in the wild in the immediate future">
                                            CR
                                            </span>
                                        </td>
                                        <td>
                                            <a href="references/1830">IUCN (2004)</a>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            European Union (25 Member States)
                                        </td>
                                        <td>
                                            Critically Endangered
                                        </td>
                                        <td>
                                            <span class="boldUnderline" title="A taxon is Critically Endangered when the best available evidence indicates that it meets any of the criteria A to E for Critically Endangered (see Section V), and it is therefore considered to be facing an extremely high risk of extinction in the wild.">
                                            CR
                                            </span>
                                        </td>
                                        <td>
                                            <a href="references/2341">IUCN (2009)</a>
                                        </td>
                                    </tr>

                                    <tr class="zebraeven">
                                        <td>
                                            Europe
                                        </td>
                                        <td>
                                            Critically Endangered
                                        </td>
                                        <td>
                                             <span class="boldUnderline" title="A taxon is Critically Endangered when the best available evidence indicates
                                                   that it meets any of the criteria A to E for Critically Endangered (see Section V), and it is therefore
                                                         considered to be facing an extremely high risk of extinction in the wild.">
                                           CR
                                           </span>
                                        </td>
                                        <td>
                                            <a href="references/2341">IUCN (2009)</a>
                                        </td>
                                    </tr>

                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Threat status other resources overlay -->
                        <div class="overlay" id="threat-status-overlay">

                            <p>
                                <a href="http://www.iucnredlist.org/apps/redlist/details/12520/0">IUCN Red List page</a>
                            </p>


                        </div>

                    </div>
                </div>

                <div class="right-area conservation-status">
                    <h3>EU's conservation status by biogeographical regions</h3>

                    <div class="map-view">
                        <img src="<%=request.getContextPath()%>/images/biogeograpical-service.png"/>
                    </div>

                    <div class="footer">
                        <!-- Table definition dropdown example -->
                        <div class="table-definition contain-float">
                            <span class="table-definition-target standardButton float-left">
                                See full table details
                            </span>
                            <a href="#conservation-status-overlay" rel="#conservation-status-overlay" class="float-right">Other resources</a>
                            <div class="table-definition-body visualClear">
                                <div style="margin-top:20px">
                                    <p style="font-weight:bold">Biogeographical
                                        assessment of the conservation status of the
                                        species:</p>

                                    <div style="overflow-x:auto">
                                        <span class="pagebanner">One item found.</span>
                                        <span class="pagelinks"><strong>1</strong></span>
                                        <table style="margin-top:20px"
                                               class="datatable listing inline-block">
                                            <thead>
                                            <tr>
                                                <th class="dt_sortable">
                                                    <a href="/species/1442/conservation_status?d-49653-s=0&amp;tab=conservation_status&amp;d-49653-o=2&amp;d-49653-p=1&amp;idSpecies=1442">coverage</a>
                                                </th>
                                                <th class="dt_sortable">
                                                    <a href="/species/1442/conservation_status?d-49653-s=1&amp;tab=conservation_status&amp;d-49653-o=2&amp;d-49653-p=1&amp;idSpecies=1442">region</a>
                                                </th>
                                                <th class="dt_sortable">
                                                    <a href="/species/1442/conservation_status?d-49653-s=2&amp;tab=conservation_status&amp;d-49653-o=2&amp;d-49653-p=1&amp;idSpecies=1442">assessment</a>
                                                </th>
                                                <th class="dt_sortable">
                                                    <a href="/species/1442/conservation_status?d-49653-s=3&amp;tab=conservation_status&amp;d-49653-o=2&amp;d-49653-p=1&amp;idSpecies=1442">period</a>
                                                </th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <tr class="zebraodd">
                                                <td>EU25</td>
                                                <td>Mediterranean</td>
                                                <td>Bad (U2)</td>
                                                <td>2001-2006</td></tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div style="margin-top:20px">
                                    <p style="font-weight:bold">Country-level
                                        assessment of the conservation status of the
                                        species:</p>

                                    <div style="overflow-x:auto ">
                                        <span class="pagebanner">2 items found, displaying all items.</span><span
                                            class="pagelinks"><strong>1</strong></span>
                                        <table style="margin-top:20px"
                                               class="datatable listing inline-block">
                                            <thead>
                                            <tr>
                                                <th class="dt_sortable">
                                                    <a href="/species/1442/conservation_status?d-49653-s=0&amp;tab=conservation_status&amp;d-49653-o=2&amp;d-49653-p=1&amp;idSpecies=1442">country</a>
                                                </th>
                                                <th class="dt_sortable">
                                                    <a href="/species/1442/conservation_status?d-49653-s=1&amp;tab=conservation_status&amp;d-49653-o=2&amp;d-49653-p=1&amp;idSpecies=1442">region</a>
                                                </th>
                                                <th class="dt_sortable">
                                                    <a href="/species/1442/conservation_status?d-49653-s=2&amp;tab=conservation_status&amp;d-49653-o=2&amp;d-49653-p=1&amp;idSpecies=1442">assessment</a>
                                                </th>
                                                <th class="dt_sortable">
                                                    <a href="/species/1442/conservation_status?d-49653-s=3&amp;tab=conservation_status&amp;d-49653-o=2&amp;d-49653-p=1&amp;idSpecies=1442">period</a>
                                                </th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <tr class="zebraodd">
                                                <td>Portugal</td>
                                                <td>Mediterranean</td>
                                                <td>Bad (U2)</td>
                                                <td>2001-2006</td>
                                            </tr>
                                            <tr class="zebraeven">
                                                <td>Spain</td>
                                                <td>Mediterranean</td>
                                                <td>Bad and deteriorating (U2-)</td>
                                                <td>2001-2006</td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Conservation status other resources overlay -->
                        <div class="overlay" id="conservation-status-overlay">
                          <p>
                              <a href="http://bd.eionet.europa.eu/article17/speciessummary/?group=TWFtbWFscw==&amp;species=THlueCBwYXJkaW51cw==">Conservation status 2006 (art. 17)</a>
                          </p>
                          <p>
                              <a href="http://forum.eionet.europa.eu/x_habitat-art17report/library/datasheets/species/mammals/mammals/lynx_pardinuspdf">Habitats Directive Art. 17-2006 summary</a>
                          </p>

                            <p>
                                <a href="http://www.eol.org/pages/347432">Encyclopedia of Life:347432</a>
                            </p>
                            <p>
                                <a href="http://www.eu-nomen.eu/portal/taxon.php?GUID=urn:lsid:faunaeur.org:taxname:305369">PESI page (Accepted)</a>
                            </p>
                        </div>
                    </div>
                </div>
                <!-- END species status -->
</stripes:layout-definition>
