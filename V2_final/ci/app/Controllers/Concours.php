<?php
namespace App\Controllers;

use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;

class Concours extends BaseController
{
	public function afficher()
	{
		$model = model(Db_model::class);

		$data['concours'] = $model->get_all_concours();

		return view('templates/haut')
			 .view('menu_visiteur',$data)
		     .view('affichage_concours')
		     .view('templates/bas');
	}

	public function c_preselec($id){
        $model = model(Db_model::class);
        
        if($id == " "){
            return redirect()->to('/');
        }
        else{
            $data['can'] = $model->get_can_preselec($id);
            $data['cat'] = $model->get_categorie($id);
			$data['docs'] = $model->get_can_doc_preselec($id);

            return view('templates/haut')
			 .view('menu_visiteur',$data)
		     .view('candidature_preselec')
		     .view('templates/bas');
        }
    }
}
?>