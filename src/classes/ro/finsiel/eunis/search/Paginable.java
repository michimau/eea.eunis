package ro.finsiel.eunis.search;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;

import java.util.List;

/**
 * Any class implementing this interface would able to retrieve the results of a query and then serve to a given
 * object a sub-list of that result list and the total number of rows found during that query.
 * @author finsiel
 */
public interface Paginable {

  /**
   * This method is used to retrieve a sub-set of the main results of a query given its start index offset and end
   * index offset.
   * @param offsetStart The start offset (i.e. 0). If offsetStart = offSetEnd then return the whole list
   * @param pageSize The end offset (i.e. 1). If offsetStart = offSetEnd then return the whole list
   * @param sortCriteria The criteria used for sorting
   * @return A list of objects which match query criteria
   * @throws CriteriaMissingException If no criteria for searching was set.
   */
  List getResults(int offsetStart, int pageSize, AbstractSortCriteria[] sortCriteria) throws CriteriaMissingException;

  /**
   * This method is used to count the total list of results from a query. It is used to find all for use in pagination.
   * Having the total number of results and the results displayed per page, the you could find the number of pages i.e.
   * @return The total number of results
   * @throws CriteriaMissingException If no criteria for searching was set.
   */
  Long countResults() throws CriteriaMissingException;
}