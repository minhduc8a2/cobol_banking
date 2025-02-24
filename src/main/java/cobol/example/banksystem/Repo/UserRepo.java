package cobol.example.banksystem.Repo;

import cobol.example.banksystem.Models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserRepo extends JpaRepository<User, Long> {
    @Query("SELECT MAX(u.id) FROM User u")
    Long findMaxUserId();

    @Query("SELECT b.user FROM Balance b ORDER BY b.balance DESC LIMIT :n")
    List<User> findTopNUsersByBalance(@Param("n") int n);
}
