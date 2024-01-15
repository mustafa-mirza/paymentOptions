package com.avocado.options.repository;

import com.avocado.options.model.EWallet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EWalletRepository extends JpaRepository<EWallet, Long> {
    List<EWallet> findByUserId(Long userId);
    Optional<EWallet> findByIdAndUserId(Long id, Long userId);
    long countByUserId(Long userId);
    long countById(Long id);
}
