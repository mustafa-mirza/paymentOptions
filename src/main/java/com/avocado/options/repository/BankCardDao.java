package com.avocado.options.repository;

import com.avocado.options.model.BankCard;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.persistence.EntityManager;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Component
public class BankCardDao {
    @Autowired
    private DataSource dataSource;
    @Autowired
    private EntityManager em;

    public BankCardDao(DataSource dataSource, EntityManager em) {
        this.dataSource = dataSource;
        this.em = em;
    }

    public List<BankCard> searchBankCardByType(long userId, String type) {
        String sql = "SELECT * FROM bank_cards where user_id=" + userId + " and type ='" + type + "'";

        if(type.equals("All")){
            sql = "SELECT * FROM bank_cards where user_id=" + userId;
        }


        try (Connection c = dataSource.getConnection();
             ResultSet rs = c.createStatement()
                     .executeQuery(sql)) {
            List<BankCard> bankCards = new ArrayList<>();
            while (rs.next()) {
                BankCard bankCard = new BankCard();
                bankCard.setId(rs.getLong("id"));
                bankCard.setBank(rs.getString("bank"));
                bankCard.setType(rs.getString("type"));
                bankCard.setCardType(rs.getString("card_type"));
                bankCard.setCardNumber(rs.getString("card_number"));
                bankCard.setExpiryMonth(rs.getString("expiry_month"));
                bankCard.setExpiryYear(rs.getInt("expiry_year"));
                bankCard.setNameOnCard(rs.getString("name_on_card"));
                bankCards.add(bankCard);
            }

            return bankCards;
        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        }
    }

}
