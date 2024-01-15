package com.avocado.options.repository;

import com.avocado.options.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.math.BigInteger;

/**
 * Created by rajeevkumarsingh on 21/11/17.
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    User findByUsername(String username);

    @Query(value = "select 1 from users u where u.username = ?1 and u.email = ?2",
            nativeQuery = true)
    BigInteger isValidUsernameAndEmail(String username, String email);

    @Transactional
    @Modifying
    @Query(value = "update users set password = ?1 where username =?2 and email=?3",
            nativeQuery = true)
    Integer updateUserPassword(String password, String username, String email);
}
