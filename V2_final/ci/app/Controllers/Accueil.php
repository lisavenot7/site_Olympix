<?php
namespace App\Controllers;

use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;

class Accueil extends BaseController
{
	public function afficher()
	{
		$model = model(Db_model::class);

        $data['act'] = $model->get_all_actualites();
		$data['concours'] = $model->get_all_concours();

		return view('templates/haut')
			 .view('menu_visiteur',$data)
		     .view('affichage_accueil')
		     .view('templates/bas');
	}
}
?>
