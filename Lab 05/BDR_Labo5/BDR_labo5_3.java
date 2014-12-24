/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BDR_Labo5;

import java.sql.*;
import java.util.*;

/**
 * @author Simon Baehler, Sacha Bron
 */
public class BDR_Labo5_3 {

	/**
	 * @param args
	 *            the command line arguments
	 */
	public static void main(String[] args) {
		String url = "jdbc:mysql://localhost:3306/sakila";
		String utilisateur = "root";
		String motDePasse = "";
		Connection conn = null;

		try {
			conn = DriverManager.getConnection(url, utilisateur, motDePasse);
			
			// Staff
			int staffId = userGetInt("Entrez votre numéro de staff");

			String sqlStore = "SELECT store_id FROM staff WHERE staff_id = ?";

			PreparedStatement psStore = conn.prepareStatement(sqlStore);
			psStore.setInt(1, staffId);
			
			ResultSet rsStore = psStore.executeQuery();
			int storeID = -1;
			
			while (rsStore.next()) {
				storeID = rsStore.getInt("store_id");
			}
			
			if (storeID == -1) {
				System.out.println("Le staff ne travaille dans aucun magasin.");
				return;
			}

			// Acteurs
			String actor_name = userGetString("Entrez un nom de famille d'acteur");
			
			String sqlActors = "SELECT actor_id, first_name, last_name FROM actor WHERE last_name = ?";
			PreparedStatement psActors = conn.prepareStatement(sqlActors);
			psActors.setString(1, actor_name);
			ResultSet rsActors = psActors.executeQuery();

			int minActors = 1;
			int maxActors = 0;

			TreeMap<Integer, String> actorsName = new TreeMap<>();
			TreeMap<Integer, Integer> actorsId = new TreeMap<>();
			
			System.out.println("Les résultats sont:");
			while (rsActors.next()) {
				maxActors++;

				int id = rsActors.getInt("actor_id");
				String name = rsActors.getString("first_name") + " " + rsActors.getString("last_name");
				
				actorsId.put(maxActors, id);
				actorsName.put(maxActors, name);
				
				System.out.println(maxActors + ": " + name);
			}
			
			if (maxActors == 0) {
				System.out.println("Aucun acteur trouvé");
				return;
			}

			int actorId = userGetInt("Choisissez un acteur", minActors, maxActors);
			System.out.println("Vous avez choisi " + actorsName.get(actorId));
			
			// Films
			String sqlFilmActor = "SELECT F.film_id, title FROM `film_actor` AS FA INNER JOIN film AS F ON "
					+ "FA.film_id = F.film_id "
					+ "WHERE FA.actor_id = ?";
			PreparedStatement psFilmActor = conn.prepareStatement(sqlFilmActor);
			psFilmActor.setInt(1, actorId);
			ResultSet rsFilmActor = psFilmActor.executeQuery();
			
			int minFilms = 1;
			int maxFilms = 0;
			
			TreeMap<Integer, String> filmsTitle = new TreeMap<>();
			TreeMap<Integer, Integer> filmsId = new TreeMap<>();
			
			System.out.println("les résultats sont:");
			while (rsFilmActor.next()) {
				maxFilms++;

				int id = rsFilmActor.getInt("F.film_id");
				String title = rsFilmActor.getString("title");
				
				filmsId.put(maxFilms, id);
				filmsTitle.put(maxFilms, title);
				
				System.out.println(maxFilms + ": " + title);
			}

			if (maxFilms == 0) {
				System.out.println("Aucun film trouvé");
				return;
			}

			int filmId = userGetInt("Choisissez un film", minFilms, maxFilms);
			System.out.println("Vous avez choisi " + filmsTitle.get(filmId));
			
			// Exemplaires
			String sqlExemplaireFilm = "SELECT inventory_id FROM `inventory` where film_id = ?";
			PreparedStatement psExemplaireFilm = conn.prepareStatement(sqlExemplaireFilm);
			psExemplaireFilm.setInt(1, filmId);
			ResultSet rsExemplaireFilm = psExemplaireFilm.executeQuery();
			
			int minExemplaires = 1;
			int maxExemplaires = 0;
			TreeMap<Integer, Integer> exemplairesId = new TreeMap<>();
			
			System.out.println("les résultats sont:");
			while (rsExemplaireFilm.next()) {
				maxExemplaires++;
				int id = rsExemplaireFilm.getInt("inventory_id");
				exemplairesId.put(maxExemplaires, id);
				System.out.println(maxExemplaires + ": " + id);
			}

			if (maxExemplaires == 0) {
				System.out.println("Aucun exemplaire trouvé");
				return;
			}

			int exemplaireId = userGetInt("Choisissez un exemplaire", minExemplaires, maxExemplaires);
			System.out.println("Vous avez choisi " + exemplairesId.get(exemplaireId));
			
			// Client
			String lastName = userGetString("Nom du client");
			String firstName =  userGetString("Prénom du client");
			String sqlClient = "SELECT * FROM `customer` WHERE first_name = ? AND last_name = ?";
			PreparedStatement psClient = conn.prepareStatement(sqlClient);
			psClient.setString(1, firstName);
			psClient.setString(2, lastName);
			ResultSet rsClient = psClient.executeQuery();

			int customer_id = -1;
			while (rsClient.next()) {
				customer_id = rsClient.getInt("customer_id");
			}
			
			// new customer
			if (customer_id == -1) {
				System.out.println("Vous êtes un nouveau client!");

				String pays = userGetString("Pays du client");
				String sqlCountry = "SELECT * FROM `country` WHERE country = ?";
				PreparedStatement psCountry = conn.prepareStatement(sqlCountry);
				psCountry.setString(1, pays);
				ResultSet rsCountry = psCountry.executeQuery();
				
				int pays_id = -1;
				
				while (rsCountry.next()) {
					pays_id = rsCountry.getInt("country_id");
				}
				
				// new country
				if (pays_id == -1) {
					String sqlCountryInsert= "INSERT INTO country (country) VALUES (?);";
					PreparedStatement psCountryInsert = conn.prepareStatement(sqlCountryInsert, Statement.RETURN_GENERATED_KEYS);
					psCountryInsert.setString(1, pays);
					psCountryInsert.executeUpdate();
					ResultSet rsCountryInsert = psCountryInsert.getGeneratedKeys();
					
					int dernierId_pays = -1;
					
					if (rsCountryInsert.next()) {
						dernierId_pays = rsCountryInsert.getInt(1);
					}
					
					pays_id = dernierId_pays;
				}

				String city = userGetString("Ville du client");
				String sqlCity = "SELECT * FROM `city` WHERE country_id = ?";
				PreparedStatement psCity = conn.prepareStatement(sqlCity);
				psCity.setInt(1, pays_id);
				ResultSet rsCity = psCity.executeQuery();

				int cityId = -1;
				
				while (rsCity.next()) {
					cityId = rsCity.getInt("city_id");
				}
				
				// new city
				if (cityId == -1) {
					String sqlCityInsert = "INSERT INTO city(city, last_update, country_id) VALUES (?,?,?)";
					PreparedStatement psCityInsert = conn.prepareStatement(sqlCityInsert, Statement.RETURN_GENERATED_KEYS);
					psCityInsert.setString(1, city);
					Timestamp time = new Timestamp(System.currentTimeMillis());
					psCityInsert.setTimestamp(2, time);
					psCityInsert.setInt(3, pays_id);
					psCityInsert.executeUpdate();
					
					ResultSet rsCityInsert = psCityInsert.getGeneratedKeys();
					int dernierId_ville = 0;
					
					if (rsCityInsert != null && rsCityInsert.first()) {
						dernierId_ville = rsCityInsert.getInt(1);
					}
					
					cityId = dernierId_ville;
				}

				// Insertion au niveau de l'adresse du client
				String sqlAddressInsert = "INSERT INTO address(last_update , city_id, address, district, phone, postal_code) VALUES (?,?,?,?,?,?)";

				PreparedStatement psAddressInsert = conn.prepareStatement(sqlAddressInsert, Statement.RETURN_GENERATED_KEYS);
				String address = userGetString("Adresse du client");
				String district = userGetString("District du client");
				String email = userGetString("Adresse email du client");
				String postalCode = userGetString("Code Postal du client");
				String phone = userGetString("Numéro de téléphone du client");
				
				Timestamp time = new Timestamp(System.currentTimeMillis());
				psAddressInsert.setTimestamp(1, time);
				psAddressInsert.setInt(2, cityId);
				psAddressInsert.setString(3, address);
				psAddressInsert.setString(4, district);
				psAddressInsert.setString(5, phone);
				psAddressInsert.setString(6, postalCode);
				psAddressInsert.executeUpdate();
				
				ResultSet rsAddressInsert = psAddressInsert.getGeneratedKeys();
				
				int addressId = 0;
				if (rsAddressInsert != null && rsAddressInsert.first()) {
					addressId = rsAddressInsert.getInt(1);
				}
				
				// insertion du client
				String sqlCustInsert = "INSERT INTO customer(first_name, last_name, last_update, store_id, address_id, create_date, email)"
						+ " VALUES (?,?,?,?,?,?,?)";
				PreparedStatement psCustInsert = conn.prepareStatement(sqlCustInsert, Statement.RETURN_GENERATED_KEYS);
				psCustInsert.setString(1, firstName);
				psCustInsert.setString(2, lastName);
				time = new Timestamp(System.currentTimeMillis());
				psCustInsert.setTimestamp(3, time);
				psCustInsert.setInt(4, storeID);
				psCustInsert.setInt(5, addressId);
				psCustInsert.setTimestamp(6, time);
				psCustInsert.setString(7, email);
				psCustInsert.executeUpdate();
				
				ResultSet rsCustInsert = psCustInsert.getGeneratedKeys();
				
				if (rsCustInsert.next()) {
					customer_id = rsCustInsert.getInt(1);
				}
			}
			
			// Client existant ou créé
			System.out.println("Client id:" + customer_id);
			
			Statement stmt = conn.createStatement();
			ResultSet rsRentalCount = stmt.executeQuery("SELECT COUNT(return_date) FROM rental WHERE return_date IS NULL AND customer_id = customer_id");
			
			int NBlocation = 0;
			while (rsRentalCount.next()) {
				NBlocation = rsRentalCount.getInt(1);
			}
			
			if (NBlocation < 10) {
				String sqlRentalInsert = "INSERT INTO rental(customer_id, rental_date, inventory_id , staff_id , last_update) values (?,?,?,?,?)";
				PreparedStatement psRentalInsert = conn.prepareStatement(sqlRentalInsert);
				
				psRentalInsert.setInt(1, customer_id);
				Timestamp time = new Timestamp(System.currentTimeMillis());
				psRentalInsert.setTimestamp(2, time);
				psRentalInsert.setInt(3, exemplaireId);
				psRentalInsert.setInt(4, staffId);
				psRentalInsert.setTimestamp(5, time);

				psRentalInsert.executeUpdate();
			} else {
				System.out.println("location impossilbe");
			}
		} catch (Exception ex) {
			ex.printStackTrace();

		} finally {
			// Step 5: Always free resources
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}

	public static int userGetInt(String msg) {
		try {
			System.out.println(msg + ":");
			Scanner in = new Scanner(System.in);
			return in.nextInt();
		} catch (Exception e){
			System.out.println("Erreur: entrez un nombre.");
			return userGetInt(msg);
		}
	}
	
	public static int userGetInt(String msg, int min, int max) {
		int ret;
		boolean firstAttempt = true;
		
		do {
			if (!firstAttempt) {
				System.out.println("Erreur: élément invalide.");
			}
			
			firstAttempt = false;
			
			ret = userGetInt(msg + " (" + min + "-" + max + ")");
		} while (ret < min || ret > max);
		
		return ret;
	}
	
	public static String userGetString(String msg) {
		try {
			System.out.println(msg + ":");
			Scanner in = new Scanner(System.in);
			return in.next();
		} catch (Exception e){
			System.out.println("Erreur: entrez une chaîne de caratères.");
			return userGetString(msg);
		}
	}
}
