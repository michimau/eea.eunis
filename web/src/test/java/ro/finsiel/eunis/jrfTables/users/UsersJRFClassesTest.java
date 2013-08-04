package ro.finsiel.eunis.jrfTables.users;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class UsersJRFClassesTest {

    @Test
    public void test_RightsDomain() {
        RightsDomain instance = new RightsDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_RightsPersist() {
        RightsPersist instance = new RightsPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_RolesDomain() {
        RolesDomain instance = new RolesDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_RolesPersist() {
        RolesPersist instance = new RolesPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_RolesRightsDomain() {
        RolesRightsDomain instance = new RolesRightsDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_RolesRightsPersist() {
        RolesRightsPersist instance = new RolesRightsPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_RolesRightsSimpleDomain() {
        RolesRightsSimpleDomain instance = new RolesRightsSimpleDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_RolesRightsSimplePersist() {
        RolesRightsSimplePersist instance = new RolesRightsSimplePersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_UserDomain() {
        UserDomain instance = new UserDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_UserPersist() {
        UserPersist instance = new UserPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_UsersRightsDomain() {
        UsersRightsDomain instance = new UsersRightsDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_UsersRightsPersist() {
        UsersRightsPersist instance = new UsersRightsPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_UsersRolesDomain() {
        UsersRolesDomain instance = new UsersRolesDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_UsersRolesPersist() {
        UsersRolesPersist instance = new UsersRolesPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
