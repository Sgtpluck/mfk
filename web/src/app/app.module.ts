import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';
import { WikipediaSearchComponent } from './wikipedia/wikipedia-search.component'
import { WikipediaService } from './/wikipedia/wikipedia.service';
import { AppComponent } from './app.component';

@NgModule({
  declarations: [
    AppComponent,
    WikipediaSearchComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    ReactiveFormsModule
  ],
  providers: [WikipediaService],
  bootstrap: [AppComponent]
})
export class AppModule { }
