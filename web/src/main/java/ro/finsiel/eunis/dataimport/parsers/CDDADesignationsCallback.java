package ro.finsiel.eunis.dataimport.parsers;

import eionet.eunis.util.Pair;

import java.util.ArrayList;
import java.util.List;

/**
 * Parses the CDDA designation category (http://dd.eionet.europa.eu/CodelistServlet?id=66479&type=ELM&format=xml)
 */
public class CDDADesignationsCallback {

    private List<Pair<String, String>> resultList;

    public CDDADesignationsCallback() {
        resultList = new ArrayList<Pair<String, String>>();
    }

    /**
     * Definition reader
     */
    @CallbackSAXParser.SaxCallback("dd:value-lists.dd:value-list.dd:value")
    public void callDefinition(String path, CallbackSAXParser.Values values) {
        String definition = values.getFromCurrent("dd:definition");
        String description = values.getFromCurrent("dd:shortDescription");
        description = description.replaceAll(" ", "_").toUpperCase();
        Pair<String, String> pair = new Pair(description, definition);
        resultList.add(pair);
    }

    /**
     * Returns the list of read results
     * @return list of pairs; the ID is upper cased + underscored
     */
    public List<Pair<String, String>> getResultList() {
        return resultList;
    }
}
