<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
               <!-- quick facts -->

               <!--  Gallery on left -->
                <div class="left-area species">

                    <div class="gallery-slider">
                        <ul class="gallery-slider-wrapper-inner items">
                            <c:forEach items="${actionBean.pics}" var="pic">
                                <li>
                                    <img src="${pic.path}/${pic.filename}" style="max-width:475px;max-height:267px;"/>
                                </li>
                            </c:forEach>
                        </ul>

                        <div class="gallery-slider-controls">
                            <a href="#" class="button-next">Next</a>
                            <a href="#" class="button-prev">Previous</a>
                            <a href="#" class="hiddenElement" id="dummy"> </a>
                        </div>
                    </div>
                    <!-- TODO add link for authenticated users to upload/delete images -->
                    <!-- TODO How to display pic license informtaion? -->
                    <p class="text-right">
                        <a href="http://images.google.com/images?q=${eunis:replaceTags(actionBean.scientificName)}">More images</a>
                    </p>
                </div>

                <!-- Textual facts on right -->
                <div class="right-area quickfacts">
                    <h2>Quick facts</h2>
                    <div class="bold">
                        <p class="firstParagraph">First named <span class="quickfact-number">1824</span>
                            as "Felis pardina" by Temminck.</p>

                        <p>It has <span class="quickfact-number">5</span>
                            <a href="#synonyms-overlay" rel="#synonyms-overlay">scientific synonyms</a> and
                            <span class="quickfact-number">22</span>
                            <a href="#common-names-overlay" rel="#common-names-overlay">common names</a>.</p>

                        <p>Protected in  <span class="quickfact-number">94</span>
                            <a href="#protected">sites in Europe</a>.</p>

                        <p>Mentioned in <span class="quickfact-number">5</span>
                            <a href="#legal-instruments">legal instruments</a>.</p>
                        <p>Lives in <span class="quickfact-number">3</span>
                            <a href="#habitat-types">habitat types</a>.</p>
                        <p class="discreet">Natura 2000 code: 1362.</p>
                        <p><a href="#generic-references-overlay" rel="#generic-references-overlay" class="float-right">Other resources</a></p>
                    </div>
                    <!-- Generic other resources overlay -->
                    <div class="overlay" id="generic-references-overlay">
                          <p>
                              <a href="http://www.faunaeur.org/full_results.php?id=305369">Fauna Europaea page</a> </p>
                          <p>
                              <a href="http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=621869">ITIS:621869 (valid)</a> </p>
                          <p>
                              <a href="http://www.catalogueoflife.org/annual-checklist/2011/details/species/id/6902507">CoL: accepted name</a> </p>
                          <p>
                              <a href="http://en.wikipedia.org/wiki/Iberian_Lynx">Wikipedia:Iberian Lynx</a> </p>
                          <p>
                              <a href="http://www.eu-nomen.eu/portal/taxon.php?GUID=urn:lsid:faunaeur.org:taxname:305369">PESI page (Accepted)</a> </p>
                          <p>
                              <a href="http://www.eol.org/pages/347432">Encyclopedia of Life:347432</a> </p>
                          <p>
                              <a href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=191816&lvl=0">NCBI:191816</a> </p>

                    </div>

                    <div class="overlay" id="synonyms-overlay">
                        <table summary="List of synonyms" class="listing fullwidth">
                            <colgroup><col style="width:40%">
                                <col style="width:60%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                                        Scientific name

                                        <img src="http://www.eea.europa.eu/arrowUp.gif" height="6" width="9"></th>
                                    <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                                        Author

                                        <img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <a href="/species/1439">Lynx pardella</a>
                                    </td>
                                    <td>
                                        Miller, 1910
                                    </td>
                                </tr>

                                <tr class="zebraeven">
                                    <td>
                                        <a href="/species/1440">Lynx pardellus</a>
                                    </td>
                                    <td>
                                        Miller, 1912
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <a href="/species/1441">Lynx pardina</a>
                                    </td>
                                    <td>
                                        (Temminck, 1827)
                                    </td>
                                </tr>

                                <tr class="zebraeven">
                                    <td>
                                        <a href="/species/14326">Felis pardina</a>
                                    </td>
                                    <td>
                                        Temminck, 1824
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <a href="/species/14327">Felis lynx pardina</a>
                                    </td>
                                    <td>
                                        Temminck, 1824
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class='overlay' id="common-names-overlay">
                        <table summary="Vernacular names" class="listing fullwidth">
                            <thead>
                            <tr>
                                <th scope="col" style="cursor: pointer;"><img
                                        src="http://www.eea.europa.eu/arrowBlank.gif"
                                        height="6" width="9">
                                    Vernacular Name

                                    <img src="http://www.eea.europa.eu/arrowUp.gif"
                                         height="6" width="9"></th>
                                <th scope="col" style="cursor: pointer;"><img
                                        src="http://www.eea.europa.eu/arrowBlank.gif"
                                        height="6" width="9">
                                    Language

                                    <img src="http://www.eea.europa.eu/arrowBlank.gif"
                                         height="6" width="9"></th>
                                <th scope="col" style="cursor: pointer;"><img
                                        src="http://www.eea.europa.eu/arrowBlank.gif"
                                        height="6" width="9">
                                    Reference

                                    <img src="http://www.eea.europa.eu/arrowBlank.gif"
                                         height="6" width="9"></th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td xml:lang="en">
                                    Iberian lynx
                                </td>
                                <td>
                                    English
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr class="zebraeven">
                                <td xml:lang="sl">
                                    Iberijski ris
                                </td>
                                <td>
                                    Slovenian
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr>
                                <td xml:lang="hr">
                                    Iberski ris
                                </td>
                                <td>
                                    Croatian
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr class="zebraeven">
                                <td xml:lang="pt">
                                    Liberne
                                </td>
                                <td>
                                    Portuguese
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr>
                                <td xml:lang="pt">
                                    Lince ibérico
                                </td>
                                <td>
                                    Portuguese
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1579">EC-DGXI.d2,
                                        ETC/NC</a>
                                </td>
                            </tr>
                            <tr class="zebraeven">
                                <td xml:lang="es">
                                    Lince iberico
                                </td>
                                <td>
                                    Spanish
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr>
                                <td xml:lang="it">
                                    Lince pardina
                                </td>
                                <td>
                                    Italian
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr class="zebraeven">
                                <td xml:lang="pt">
                                    Lince-ibérico
                                </td>
                                <td>
                                    Portuguese
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr>
                                <td xml:lang="fr">
                                    Lynx pardelle
                                </td>
                                <td>
                                    French
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr class="zebraeven">
                                <td xml:lang="no">
                                    Pantergaupe
                                </td>
                                <td>
                                    Norwegian
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr>
                                <td xml:lang="sv">
                                    Panterlo
                                </td>
                                <td>
                                    Swedish
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr class="zebraeven">
                                <td xml:lang="fi">
                                    Pantteri-ilves
                                </td>
                                <td>
                                    Finnish
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr>
                                <td xml:lang="en">
                                    Pardel lynx
                                </td>
                                <td>
                                    English
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr class="zebraeven">
                                <td xml:lang="da">
                                    Pardellos
                                </td>
                                <td>
                                    Danish
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr>
                                <td xml:lang="de">
                                    Pardelluchs
                                </td>
                                <td>
                                    German
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr class="zebraeven">
                                <td xml:lang="nl">
                                    Pardellynx
                                </td>
                                <td>
                                    Dutch
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr>
                                <td xml:lang="hu">
                                    Párduchiúz
                                </td>
                                <td>
                                    Hungarian
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr class="zebraeven">
                                <td xml:lang="et">
                                    Pürenee ilves
                                </td>
                                <td>
                                    Estonian
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr>
                                <td xml:lang="cs">
                                    Rys pardálový
                                </td>
                                <td>
                                    Czech
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr class="zebraeven">
                                <td xml:lang="sk">
                                    Rys škvnitý
                                </td>
                                <td>
                                    Slovak
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            <tr>
                                <td xml:lang="nl">
                                    Spaanse lyns
                                </td>
                                <td>
                                    Dutch
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1579">EC-DGXI.d2,
                                        ETC/NC</a>
                                </td>
                            </tr>
                            <tr class="zebraeven">
                                <td xml:lang="is">
                                    Spánargaupa
                                </td>
                                <td>
                                    Icelandic
                                </td>
                                <td>
                                    <a class="link-plain" href="references/1599">Mitchell-Jones,
                                        A.J. &amp; al.</a>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="visualClear"></div>
                <!-- END quick facts -->
</stripes:layout-definition>