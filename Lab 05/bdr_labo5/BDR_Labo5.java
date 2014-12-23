/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package bdr_labo5;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.*;
import java.io.*;
import java.util.LinkedList;
import java.util.*;

/**
 *
 * @author Simon
 */
public class BDR_Labo5 {

    /**
     * @param args the command line arguments
     */
    //retourn l'object choisie parmi les résultat de la requete
    public static void main(String[] args) {

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        String url = "jdbc:mysql://localhost:3306/sakila";
        String utilisateur = "root";
        String motDePasse = "";

        /* Chargement du driver JDBC pour MySQL */
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {

        }

        try {
            conn = DriverManager.getConnection(url, utilisateur, motDePasse);
            stmt = conn.createStatement();

            //Exercie 1
            System.out.println("--- Exercice 1 ---");
            rs = stmt.executeQuery("SELECT * FROM film LIMIT 10");
            System.out.println("Les résultats sont :");
            
            while (rs.next()) {
                for (int i = 1; i < rs.getMetaData().getColumnCount(); i++) {
                    String col = rs.getMetaData().getColumnName(i);
                    String title = rs.getString(col);
                    
                    String separator = (i > 1) ? " | " : "";
                    	
                    System.out.print(separator + title);
                }
                
                System.out.println();
            }

            //Exercice 2
            System.out.println("\n--- Exercice 2 ---");
            try {
                String first_name;
                String lastname_name;
                PreparedStatement preparedStatement;
                BufferedReader bufferRead = new BufferedReader(new InputStreamReader(System.in));
                
                for (int i = 0; i < 10; i++) {
                    System.out.println("Entrez un prénom:");
                    first_name = bufferRead.readLine();
                    
                    System.out.println("Entrez un nom de famille:");
                    lastname_name = bufferRead.readLine();

                    preparedStatement = conn.prepareStatement("INSERT INTO sakila.actor (first_name, last_name) VALUES (?,?)");
                    preparedStatement.setString(1, first_name);
                    preparedStatement.setString(2, lastname_name);
                    preparedStatement.executeUpdate();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            
            //Exercie 4
            System.out.println("\n--- Exercice 4 ---");
            try {
                String catName = "";
                BufferedReader bufferRead = new BufferedReader(new InputStreamReader(System.in));
                System.out.println("Entez un nom de catégorie:");
                catName = bufferRead.readLine();
                String sql = "{CALL NBRFILM_C(?,?)}";
                CallableStatement callNombreFilm = conn.prepareCall(sql);
                callNombreFilm.setString(1, catName);
                callNombreFilm.execute();
                System.out.println(callNombreFilm.getInt(2));

                Statement stmtrs = conn.createStatement();

                ResultSet rsFilm = stmtrs.executeQuery("SELECT * FROM category");
                System.out.println("les résultats sont:");
                while (rsFilm.next()) {
                    String name = rsFilm.getString("name");
                    callNombreFilm = conn.prepareCall(sql);
                    callNombreFilm.setString(1, name);
                    callNombreFilm.execute();
                    System.out.println(name);
                    System.out.println(callNombreFilm.getInt(2));
                    System.out.println();
                }

            } catch (IOException e) {
                e.printStackTrace();
            }
            
            //Exercice 5
            System.out.println("\n --- Exercice 5 ---");
            String sqlDropView = " DROP VIEW IF EXISTS revenu_par_localite";
            Statement stDropView = conn.createStatement();
            stDropView.executeUpdate(sqlDropView);

            String sqlCreateView = "CREATE VIEW revenu_par_localite AS \n"
                    + "SELECT ci.city,A.postal_code,CO.country,SUM(amount) \n"
                    + "	FROM payment AS P \n"
                    + "	INNER JOIN rental AS R \n"
                    + "		ON R.rental_id = P.rental_id \n"
                    + "	INNER JOIN customer AS C \n"
                    + "		ON P.customer_id = C.customer_id \n"
                    + "	INNER JOIN address AS A \n"
                    + "		ON a.address_id = C.address_id \n"
                    + "	INNER JOIN city as Ci \n"
                    + "		ON Ci.city_id = A.city_id \n"
                    + "	INNER JOIN country AS CO \n"
                    + "		ON Co.country_id = Ci.country_id \n"
                    + "	group by ci.city";

            Statement stCreateView = conn.createStatement();
            stCreateView.executeUpdate(sqlCreateView);

            try {
                String country = "";
                String sqlRevenuContry;
                BufferedReader bufferRead = new BufferedReader(new InputStreamReader(System.in));
                System.out.println("Entez un nom de pays:");
                country = bufferRead.readLine();
                sqlRevenuContry = "SELECT * FROM `revenu_par_localite` where `country` = '" + country + "'";
                ResultSet revenueRS = stmt.executeQuery(sqlRevenuContry);

                System.out.println("les résultats sont :\n");
                while (revenueRS.next()) {
                    for (int i = 1; i < revenueRS.getMetaData().getColumnCount(); i++) {
                        String col = revenueRS.getMetaData().getColumnName(i);
                        String title = revenueRS.getString(col);
                        System.out.print(title + " ");
                    }
                    System.out.println();
                }

            } catch (IOException e) {
                e.printStackTrace();
            }

        } catch (SQLException ex) {
            ex.printStackTrace();

        } finally {
            // Step 5: Always free resources
            try {
                if (stmt != null) {
                    stmt.close();  // This closes ResultSet too
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

}
