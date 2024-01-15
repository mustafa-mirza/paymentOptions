package com.avocado.options.repository;

import com.avocado.options.model.Address;
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
public class BillingAddressDao {
    @Autowired
    private DataSource dataSource;
    @Autowired
    private EntityManager em;

    public BillingAddressDao(DataSource dataSource, EntityManager em) {
        this.dataSource = dataSource;
        this.em = em;
    }

    public List<Address> searchAddress(long userId, String address) {
        if(address.contains("*")){
            address = address.replace("*", "%");
        }
        String sql = "SELECT * FROM addresses where user_id=" + userId + " and address_line Like '" + address + "'";
        if(!address.contains("%")){
            sql = "SELECT * FROM addresses where user_id=" + userId + " and address_line Like '%" + address + "%'";
        }

        try (Connection c = dataSource.getConnection();
             ResultSet rs = c.createStatement()
                     .executeQuery(sql)) {
            List<Address> addressList = new ArrayList<>();

            while (rs.next()) {
                Address addressData = new Address();
                addressData.setId(rs.getLong("id"));
                addressData.setType(rs.getString("type"));
                addressData.setAddressLine(rs.getString("address_line"));
                addressData.setCity(rs.getString("city"));
                addressData.setState(rs.getString("state"));
                addressData.setCountry(rs.getString("country"));
                addressData.setZipCode(rs.getInt("zip_code"));
                addressList.add(addressData);
            }

            return addressList;
        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        }
    }

}
