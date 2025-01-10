<?php
use CodeIgniter\Router\RouteCollection;
use App\Controllers\Accueil;

use App\Controllers\Compte;

use App\Controllers\Actualite;

use App\Controllers\Concours;

use App\Controllers\Candidature;
/** *
@var RouteCollection $routes
*/

$routes->get('/',[Accueil::class, 'afficher']);
$routes->get('../accueil/afficher',[Accueil::class, 'afficher']);

$routes->get('compte/lister', [Compte::class, 'lister']);

$routes->get('actualite/afficher', [Actualite::class, 'afficher']);
$routes->get('actualite/afficher/(:num)', [Actualite::class, 'afficher']);

$routes->get('concours/afficher', [Concours::class, 'afficher']);

$routes->get('compte/creer', [Compte::class, 'creer']);
$routes->post('compte/creer', [Compte::class, 'creer']);

$routes->get('candidature/afficher', [Candidature::class, 'afficher']);
$routes->get('candidature/afficher/(:alphanum)', [Candidature::class, 'afficher']);

$routes->get('candidature/supprimer/(:alphanum)/(:alphanum)', [Candidature::class, 'supprimer']);

$routes->get('candidature/suivi', [Candidature::class, 'suivi']);
$routes->post('candidature/suivi', [Candidature::class, 'suivi']);

$routes->get('compte/connecter', [Compte::class, 'connecter']);
$routes->post('compte/connecter', [Compte::class, 'connecter']);

$routes->get('compte/deconnecter', [Compte::class, 'deconnecter']);

$routes->get('compte/afficher_profil', [Compte::class, 'afficher_profil']); 

$routes->get('compte/concours_jury', [Compte::class, 'concours_jury']); 
$routes->get('compte/concours_admin', [Compte::class, 'concours_admin']); 

$routes->get('compte/c_preselectionner', [Compte::class, 'c_preselec']);
$routes->get('compte/c_preselectionner/(:num)', [Compte::class, 'c_preselec']);
$routes->get('compte/c_preselection', [Compte::class, 'c_preselection']);
$routes->get('compte/c_preselection/(:num)', [Compte::class, 'c_preselection']);

$routes->get('compte/comptes', [Compte::class, 'lister']);

$routes->get('compte/modifier', [Compte::class, 'modifier']); 
$routes->post('compte/modifier', [Compte::class, 'modifier']); 

$routes->get('concours/c_preselection', [Concours::class, 'c_preselec']);
$routes->get('concours/c_preselection/(:num)', [Concours::class, 'c_preselec']);

$routes->get('compte/ajouter_concours', [Compte::class, 'ajouter_c']); 
$routes->post('compte/ajouter_concours', [Compte::class, 'ajouter_c']); 

$routes->get('compte/ajouter_comptes', [Compte::class, 'ajouter_comptes']); 
$routes->post('compte/ajouter_comptes', [Compte::class, 'ajouter_comptes']); 



$routes->get('compte/supprimer/(:num)/(:alphanum)', [Compte::class, 'supprimer_con']);