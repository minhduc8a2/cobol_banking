package cobol.example.banksystem.Repo;

import cobol.example.banksystem.Models.Balance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface BalanceRepo extends JpaRepository<Balance, Long> {
    @Query(value = "SELECT SUM(balance) FROM (SELECT balance FROM balances ORDER BY balance DESC LIMIT :n) as top_balances", nativeQuery = true)
    Double getSumOfTopNBalances(@Param("n") int n);
}
