package cobol.example.banksystem.Models;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "balances")
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class Balance {

    @Id
    private Long id;  // This acts as the primary key, same as user_id

    @OneToOne(cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.REFRESH})
    @MapsId  // Maps this to the 'id' field
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "balance")
    private double balance;
}
