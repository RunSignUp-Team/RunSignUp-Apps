package com.ibly31.runsignup;

import java.text.SimpleDateFormat;
import java.util.Date;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.text.format.DateFormat;
import android.text.format.Time;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

public class MainMenuActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_menu);
        
        TextView copyrightView = (TextView)findViewById(R.id.copyrightView);
        Time time = new Time();
        time.setToNow();
        
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy");
        
        copyrightView.setText("© " + formatter.format(new Date()) + " RunSignUp, LLC");
        
        Button findRace = (Button)findViewById(R.id.buttonFindRace);
        Button signIn = (Button)findViewById(R.id.buttonSignIn);
        Button signUp = (Button)findViewById(R.id.buttonSignUp);
        
        signIn.setOnClickListener(new OnClickListener(){
        	@Override
        	public void onClick(View v){
        		Intent intent = new Intent(v.getContext(), SignInActivity.class);
        		startActivity(intent);
        	}
        });
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main_menu, menu);
        return true;
    }
    
}
