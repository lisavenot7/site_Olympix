<?= session()->getFlashdata('error') ?>

</br>
<?php
// Création d’un formulaire qui pointe vers l’URL de base + /compte/creer
echo form_open('/compte/ajouter_comptes'); ?>
<?= csrf_field() ?>

<div class="container">
<h1 >Ajout d'un nouveau compte</h1>
</br>

<h5>
</br>
<label for="nom">Pseudo : </label>
<input type='input' style='width:405px;' name='pseudo' value=''>
</br></br>
<label for="prenom">Prénom : </label>
<input type='input' style='width:400px;' name='prenom' value=''>
</br>
</br>
<label for="nom">Nom : </label>
<input type='input' style='width:425px;' name='nom' value=''>
</br>
</br>
<label for="mdp">Mot de passe : </label>
<input type="password" style="width:350px;" name="mdp" value="">
</br>
</br>
<label for="mdp2"> Validation du mot de passe : </label>
<input type="password" style="width:225px;" name="mdp2" value="">
</br></br>
<form>
  <div class="form-row align-items-center">
    <div class="col-auto my-1">
      <label class="mr-sm-2" for="inlineFormCustomSelect">Role</label>
      <select class="custom-select mr-sm-2" name="role" style="width:440px;">
        <option value=''>Selectionner un role</option>
        <option value='A'>Administrateur</option>
        <option value='J'>Membre du jury</option>
      </select>
    </div>
  </div>
</form>
</br>
</h5>

<h2> Si le compte à ajouté est un membre de jury</h2>
</br>
<h5>
<label for="nom">Discipline Experte : </label>
<input type='input' style='width:305px;' name='de' value=''>
</br>
</br>
<label for="nom">URL : </label>
<input type='input' style='width:430px;' name='url' value=''>
</br>

</br>
<label for="nom">Biographie : </label>
<textarea class='form-control' style='width:480px;height: 100px;' name='bio' ></textarea>
</br> 

</br></br>
<input type="submit" class="btn btn-dark btn-lg btn-block" name="submit" value="Ajouter un compte"></br></br>
</br><?= validation_show_error('prenom') ?>
</br><?= validation_show_error('nom') ?>
</br><?= validation_show_error('pseudo') ?>
</br><?= validation_show_error('mdp') ?>
</br><?= validation_show_error('mdp2') ?>
</br><?= validation_show_error('role') ?>
</br><?= validation_show_error('de') ?>
</br><?= validation_show_error('url') ?>
</br><?= validation_show_error('bio') ?>
</br>



</h5>
</div>