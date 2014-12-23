/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BDR_Labo5;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.*;
import java.io.*;
import java.util.LinkedList;
import java.util.*;

/**
 * @author Simon Baehler, Sacha Bron
 */
public class BDR_Labo5_2 {
	/**
	 * retourne l'object choisie parmi les résultat de la requete
	 */
	public static void main(String[] args) {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String url = "jdbc:mysql://localhost:3306/sakila";
		String utilisateur = "root";
		String motDePasse = "";

		try {
			conn = DriverManager.getConnection(url, utilisateur, motDePasse);
			stmt = conn.createStatement();

			// Exercice 2
			System.out.println("\n--- Exercice 2 ---");
			try {
				String first_name;
				String lastname_name;
				PreparedStatement preparedStatement;
				BufferedReader bufferRead = new BufferedReader(
						new InputStreamReader(System.in));

				for (int i = 0; i < 10; i++) {
					System.out.println("Entrez un prénom:");
					first_name = bufferRead.readLine();

					System.out.println("Entrez un nom de famille:");
					lastname_name = bufferRead.readLine();

					preparedStatement = conn
							.prepareStatement("INSERT INTO sakila.actor (first_name, last_name) VALUES (?,?)");
					preparedStatement.setString(1, first_name);
					preparedStatement.setString(2, lastname_name);
					preparedStatement.executeUpdate();
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
					stmt.close(); // This closes ResultSet too
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
