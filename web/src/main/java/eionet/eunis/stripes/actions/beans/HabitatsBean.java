package eionet.eunis.stripes.actions.beans;

import ro.finsiel.eunis.jrfTables.sites.factsheet.SiteHabitatsPersist;

/**
* Unify the habitats for easy display
*/
public class HabitatsBean {
    private SiteHabitatsPersist habitat;
    private String cover;

    public HabitatsBean(SiteHabitatsPersist habitat, String cover){
        this.habitat = habitat;
        this.cover = cover;
    }

    public String getCover() {
        return cover;
    }

    public SiteHabitatsPersist getHabitat() {
        return habitat;
    }
}
