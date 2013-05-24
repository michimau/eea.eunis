<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
                <!-- species reported -->
                <div class="reported-areas">
                    <h2>Areas where this species has been reported</h2>
                    <div class="left-area reported-areas-fieldset">
                        <fieldset>
                            <legend><strong>Select layer</strong></legend>

                            <label for="distribution-range">
                                <input type="checkbox" name="checkbox"
                                       id="distribution-range">
                                Distribution range(2012,
                                source: Art 17 Habitat Directive)
                            </label>
                            <p class="discreet">User friendly explanation on why
                                one
                                should select this data layer</p>

                            <label>
                                <input type="checkbox" name="checkbox2">
                                Distribution range(2010, source: IUCN)
                            </label>
                            <p class="discreet">User friendly explanation on why
                                one
                                should select this data layer</p>

                            <label>
                                <input type="checkbox" name="checkbox3">
                                Single observations (1800-now, source: GBIF)
                            </label>
                            <p class="discreet">User friendly explanation on why
                                one
                                should select this data layer</p>
                            <label>
                                <input type="checkbox" name="checkbox4">
                                Protected sites where species is reported(2011,
                                source: Natura 2000)
                            </label>
                            <p class="discreet">User friendly explanation on why
                                one
                                should select this data layer</p>


                        </fieldset>
                        <fieldset>
                            <legend><strong>Base map - not species related</strong></legend>
                            <label>
                                <input type="checkbox" name="checkbox5">
                                All nationally designated sites (2012, source:
                                CDDA)
                            </label>
                            <p class="discreet">User friendly explanation on why
                                one
                                should select this data layer</p>
                            <label for="bio_regions">
                                <input type="checkbox" class="list_item" id="bio_regions" onclick="updateLayerVisibility('bio_regions');">
                                Bio-geographical regions
                            </label>
                            <p class="discreet">User friendly explanation on why
                                one
                                should select this data layer</p>
                            <label for="river_basin">
                                <input type="checkbox" class="list_item" id="river_basin" onclick="updateLayerVisibility('river_basin');">
                                River basin districts
                            </label>
                            <p class="discreet">User friendly explanation on why
                                one
                                should select this data layer</p>
                        </fieldset>
                    </div>

                    <div class="right-area reported-areas-map">
                        <div class="map-view">
                            <img src="biogeograpical-service.png" />
                            <p>Map depicts reported distribution of
                                species by Member States</p>
                            <a href="#">Source: Art 17 Habitat Directive</a>
                        </div>
                    </div>
                </div>
                <!-- END species reported -->
</stripes:layout-definition>
