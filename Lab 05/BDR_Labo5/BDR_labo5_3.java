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
 *
 * @author Simon
 */
public class BDR_labo5_3 {

	/**
	 * @param args
	 *            the command line arguments
	 */
	public static void main(String[] args) {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Timestamp time = null;
		PreparedStatement preparedStatement = null;

		String url = "jdbc:mysql://localhost:3306/sakila";
		String utilisateur = "root";
		String motDePasse = "";

		try {
			conn = DriverManager.getConnection(url, utilisateur, motDePasse);
			stmt = conn.createStatement();

			String staffId;
			String actor_name;
			BufferedReader bufferRead = new BufferedReader(
					new InputStreamReader(System.in));

			System.out.println("Entez votre numéro de staff:");
			staffId = bufferRead.readLine();

			String sqlStror = "SELECT store_id FROM staff where staff_id = '"
					+ staffId + "'";
			rs = stmt.executeQuery(sqlStror);
			String storeID = "";
			while (rs.next()) {
				storeID = rs.getString("store_id");
			}

			System.out.println("Entez un nom de famille d'acteur:");
			actor_name = bufferRead.readLine();
			String sqlActors = "SELECT * FROM actor where last_name = '"
					+ actor_name + "'";
			rs = stmt.executeQuery(sqlActors);

			LinkedList list = new LinkedList();
			LinkedList list2 = new LinkedList();
			System.out.println("les résultats sont:");
			while (rs.next()) {
				String actor = "";
				for (int j = 2; j < rs.getMetaData().getColumnCount(); j++) {
					String col = rs.getMetaData().getColumnName(j);
					String title = rs.getString(col);
					actor += title + " ";

				}
				list2.add(rs.getString("actor_id"));
				list.add(actor);
			}
			Iterator it = list.iterator();
			int x = 1;
			while (it.hasNext()) {
				System.out.print(x + " ");
				Object o = it.next();
				System.out.println(o);
				x++;
			}

			if (list.size() > 0) {
				boolean choixCorr = true;
				String choix = "";
				Object oChoix = "";
				while (choixCorr) {
					System.out.println("Entez la ligne:");
					choix = bufferRead.readLine();

					if (Integer.parseInt(choix) - 1 < list.size()) {
						System.out.print("Votre choix d'acteur: ");
						System.out
								.println(list.get(Integer.parseInt(choix) - 1));
						oChoix = list2.get(Integer.parseInt(choix) - 1);
						choixCorr = false;
					} else {
						System.out.println("Votre Choix est hors borne");
					}
				}
				String sqlFilmActor = "SELECT F.film_id, title FROM `film_actor` AS FA INNER JOIN film AS F ON "
						+ "FA.film_id = F.film_id "
						+ "where FA.actor_id = "
						+ oChoix;
				rs = stmt.executeQuery(sqlFilmActor);
				LinkedList listActorFilm = new LinkedList();
				LinkedList listActorFilmID = new LinkedList();
				
				while (rs.next()) {
					String actorFilm = "";
					String id = rs.getString("F.film_id");
					String title = rs.getString("title");
					actorFilm = id + " " + title;

					listActorFilmID.add(rs.getString("F.film_id"));
					listActorFilm.add(actorFilm);
				}
				
				Iterator itr = listActorFilm.iterator();
				x = 1;

				System.out.println("les résultats sont:");
				
				while (itr.hasNext()) {
					Object element = itr.next();
					System.out.println(x + " " + element);
					x++;
				}
				
				if (listActorFilm.size() > 0) {
					choixCorr = true;
					choix = "";
					oChoix = "";
					
					while (choixCorr) {
						System.out.println("Entez la ligne:");
						choix = bufferRead.readLine();
						
						if (Integer.parseInt(choix) - 1 < list.size()) {
							System.out.print("Votre choix de film: ");
							System.out.println(listActorFilm.get(Integer
									.parseInt(choix) - 1));
							oChoix = listActorFilmID.get(Integer
									.parseInt(choix) - 1);
							System.out.println(oChoix);
							choixCorr = false;
						} else {
							System.out.println("Votre Choix est hors borne");
						}
					}
					
					String sqlExemplaireFilm = "SELECT inventory_id FROM `inventory` where film_id = " + oChoix;
					rs = stmt.executeQuery(sqlExemplaireFilm);

					LinkedList listExemplaireFilm = new LinkedList();
					System.out.println("les résultats sont :");
					
					while (rs.next()) {
						listExemplaireFilm.add(rs.getString("inventory_id"));
					}
					
					Iterator itExemplaireFilm = listExemplaireFilm.iterator();
					x = 1;
					
					while (itExemplaireFilm.hasNext()) {
						System.out.print(x + " ");
						Object o = itExemplaireFilm.next();
						System.out.println(o);
						x++;
					}
					
					if (listExemplaireFilm.size() > 0) {
						choixCorr = true;
						choix = "";
						oChoix = "";
						
						while (choixCorr) {
							System.out.println("Entez la ligne");
							choix = bufferRead.readLine();
							
							if (Integer.parseInt(choix) - 1 < list.size()) {
								System.out.print("Votre choix d exemplaire : ");
								System.out.println(listExemplaireFilm
										.get(Integer.parseInt(choix) - 1));
								oChoix = listExemplaireFilm.get(Integer
										.parseInt(choix) - 1);

								System.out.println(oChoix);
								choixCorr = false;
								System.out.print("Votre Nom : ");
								String nom = bufferRead.readLine();
								System.out.print("Votre Pernom : ");
								String prenom = bufferRead.readLine();
								String sqlClent = "SELECT customer_id FROM `customer` where first_name = '"
										+ prenom
										+ "' AND last_name = '"
										+ nom
										+ "'";
								rs = stmt.executeQuery(sqlClent);
								String customer_id = null;
								
								while (rs.next()) {
									customer_id = rs.getString("customer_id");
								}
								
								// new customer
								if (customer_id == null) {
									System.out
											.println("Vous etes un nouveau client!\n");

									System.out.println("Votre Pays :");
									String pays = bufferRead.readLine();
									rs = stmt.executeQuery(sqlClent);
									String pays_id = null;
									
									while (rs.next()) {
										pays_id = rs.getString("country_id");
									}
									
									// new country
									if (pays_id == null) {
										String resultat = "INSERT INTO country (country) VALUES('"
												+ pays + "');";
										stmt.executeUpdate(resultat,
												Statement.RETURN_GENERATED_KEYS);
										rs = stmt.getGeneratedKeys();
										int dernierId_pays = 0;
										
										if (rs != null && rs.first()) {
											dernierId_pays = rs.getInt(1);
										}
										
										pays_id = Integer
												.toString(dernierId_pays);
									}

									System.out.println("Votre ville :");
									String ville = bufferRead.readLine();
									String sqlVille = "SELECT * FROM `city` where country = "
											+ ville;
									rs = stmt.executeQuery(sqlClent);
									String ville_id = null;
									
									while (rs.next()) {
										ville_id = rs.getString("city_id");
									}
									
									// new city
									if (ville_id == null) {
										preparedStatement = conn
												.prepareStatement("insert into city("
														+ "city, last_update , country_id)"
														+ " values" + "(?,?,?)");
										preparedStatement.setString(1, ville);
										time = new Timestamp(
												System.currentTimeMillis());
										preparedStatement.setTimestamp(2, time);
										preparedStatement.setString(3, pays_id);
										preparedStatement.executeUpdate();

										String resultat = "INSERT INTO city (city, country_id) VALUES('"
												+ ville
												+ "' , '"
												+ pays_id
												+ "')";
										stmt.executeUpdate(resultat,
												Statement.RETURN_GENERATED_KEYS);
										rs = stmt.getGeneratedKeys();
										int dernierId_ville = 0;
										
										if (rs != null && rs.first()) {
											dernierId_ville = rs.getInt(1);
										}
										ville_id = Integer
												.toString(dernierId_ville);
									}

									// Insertion au niveau de l'adresse du
									// client
									preparedStatement = conn
											.prepareStatement("insert into address("
													+ " last_update , "
													+ "city_id, address)"
													+ " values" + "(?,?,?)");
									System.out.print("Votre addresse : ");
									String address = bufferRead.readLine();
									System.out.print("Votre district : ");
									String district = bufferRead.readLine();
									System.out.print("Votre phone : ");
									String phone = bufferRead.readLine();
									System.out.print("Votre email : ");
									String email = bufferRead.readLine();
									time = new Timestamp(
											System.currentTimeMillis());
									preparedStatement.setTimestamp(1, time);
									preparedStatement.setString(2, ville_id);
									preparedStatement.setString(3, address);

									// insertion du client
									preparedStatement = conn
											.prepareStatement("insert into customer("
													+ "first_name, last_name, last_update, store_id, address_id, create_date,email)"
													+ " values"
													+ "(?,?,?,?,?,?,?)");
									preparedStatement.setString(1, prenom);
									preparedStatement.setString(2, nom);
									time = new Timestamp(
											System.currentTimeMillis());
									preparedStatement.setTimestamp(3, time);
									preparedStatement.setString(4, storeID);
									preparedStatement.setTimestamp(6, time);
									preparedStatement.setString(7, email);

									String resultat = "INSERT INTO address (address, city_id,district, phone) "
											+ "VALUES('"
											+ address
											+ "', '"
											+ ville_id
											+ "' , '"
											+ district
											+ "', '" + phone + "')";
									stmt.executeUpdate(resultat,
											Statement.RETURN_GENERATED_KEYS);

									rs = stmt.getGeneratedKeys();
									int dernierId_address = 0;
									
									if (rs != null && rs.first()) {
										// on récupère l'id généré
										dernierId_address = rs.getInt(1);
									}
									preparedStatement
											.setString(
													5,
													Integer.toString(dernierId_address));
									preparedStatement.executeUpdate();

								}
								rs = stmt
										.executeQuery("select * from sakila.customer where first_name ='"
												+ prenom + "';");

								while (rs.next()) {
									customer_id = rs.getString("customer_id");
									String first_name = rs
											.getString("first_name");
									String last_name = rs
											.getString("last_name");
									String last_update = rs
											.getString("last_update");
									System.out.println(customer_id + " , "
											+ first_name + " , " + last_name
											+ " , " + last_update);

								}
								rs = stmt
										.executeQuery("select count(return_date) from rental where return_date IS NULL and customer_id = customer_id");
								String NBlocation = "";
								
								while (rs.next()) {
									NBlocation = rs.getString(1);
								}
								
								if (Integer.parseInt(NBlocation) < 10) {
									preparedStatement = conn
											.prepareStatement("insert into rental("
													+ "customer_id, rental_date, inventory_id , staff_id , last_update)"
													+ " values" + "(?,?,?,?,?)");
									preparedStatement.setString(1, customer_id);
									time = new Timestamp(
											System.currentTimeMillis());
									preparedStatement.setTimestamp(2, time);
									preparedStatement.setString(3,
											(String) oChoix);
									preparedStatement.setString(4, staffId);
									preparedStatement.setTimestamp(5, time);

									preparedStatement.executeUpdate();

								} else {
									System.out.println("location impossilbe");
								}

							} else {
								System.out
										.println("Votre Choix est hors borne");
							}
						}
					} else {
						System.out.println("Aucun exemplaire trouvé");
					}

				} else {
					System.out.println("Aucun film trouvé");
				}

			} else {
				System.out.println("Aucun acteur trouvé");
			}

		} catch (IOException e) {
			e.printStackTrace();
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
