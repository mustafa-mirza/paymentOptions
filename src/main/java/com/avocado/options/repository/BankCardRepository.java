package com.avocado.options.repository;

import com.avocado.options.model.BankCard;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BankCardRepository extends JpaRepository<BankCard, Long> {
    List<BankCard> findByUserId(Long userId);
    Optional<BankCard> findByIdAndUserId(Long id, Long userId);
    long countByUserId(Long userId);
    long countById(Long id);

    @Query(value = "select * from bank_cards b where b.user_id = :userId and b.type = :type OR '1' = '1'",
            nativeQuery = true)
    List<BankCard> findByUserIdAndType(Long userId, String type);
}
