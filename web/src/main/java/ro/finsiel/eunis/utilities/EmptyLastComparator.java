package ro.finsiel.eunis.utilities;

import java.util.Comparator;

/**
 * String comparator that puts the empty strings at the back of the list
 */
public class EmptyLastComparator implements Comparator<String> {
    private static EmptyLastComparator instance = null;
    public static EmptyLastComparator getComparator(){
        if(instance == null)
            instance = new EmptyLastComparator();
        return instance;
    }

    @Override
    public int compare(java.lang.String o1, java.lang.String o2) {
        if(o1 == null && o2 == null)
            return 0;
        if(o1 == null)
            return 1;
        if(o2 == null)
            return -1;
        if(o1.equals(o2))
            return 0;
        if(o1.isEmpty())
            return 1;
        if(o2.isEmpty())
            return -1;
        return o1.compareTo(o2);
    }
}