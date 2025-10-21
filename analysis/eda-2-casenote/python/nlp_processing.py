"""
NLP Processing Module for Case Note Analysis
Enhanced text analysis for social services case notes
Integrates with R analytical framework for three-layer analysis
"""

import pandas as pd
import numpy as np
from transformers import pipeline, AutoTokenizer, AutoModelForSequenceClassification
import re
from typing import Dict, List, Tuple
import json

class CaseNoteNLPProcessor:
    """
    Advanced NLP processing for social services case notes
    Supports sentiment analysis, risk flagging, and contextual interpretation
    """
    
    def __init__(self):
        # Initialize sentiment analysis pipeline
        self.sentiment_analyzer = pipeline(
            "sentiment-analysis",
            model="cardiffnlp/twitter-roberta-base-sentiment-latest",
            return_all_scores=True
        )
        
        # Risk flag patterns (enhanced keyword detection)
        self.risk_patterns = {
            'substance_use': [
                r'\b(substance|alcohol|drug|drinking|using|addiction|relapse)\b',
                r'\b(beer|wine|cocaine|meth|opioid|prescription)\b'
            ],
            'housing_crisis': [
                r'\b(evict|homeless|housing|shelter|couch.surf)\b',
                r'\b(behind.rent|no.place|staying.with)\b'
            ],
            'mental_health': [
                r'\b(depress|anxiety|suicidal|mental|psychiatric|therapy)\b',
                r'\b(panic|mood|bipolar|psychosis|self.harm)\b'
            ],
            'crisis_indicators': [
                r'\b(urgent|emergency|crisis|immediate|acute)\b',
                r'\b(hospital|911|intervention|safety)\b'
            ],
            'family_separation': [
                r'\b(children|kids|custody|relative|grandmother)\b',
                r'\b(removed|placed|temporary|child.services)\b'
            ]
        }
    
    def analyze_sentiment(self, text: str) -> Dict:
        """Analyze sentiment of case note text"""
        try:
            results = self.sentiment_analyzer(text)[0]
            sentiment_scores = {item['label'].lower(): item['score'] for item in results}
            
            # Determine overall sentiment
            dominant_sentiment = max(sentiment_scores, key=sentiment_scores.get)
            confidence = sentiment_scores[dominant_sentiment]
            
            return {
                'sentiment': dominant_sentiment,
                'confidence': confidence,
                'scores': sentiment_scores
            }
        except Exception as e:
            return {
                'sentiment': 'unknown',
                'confidence': 0.0,
                'scores': {},
                'error': str(e)
            }
    
    def extract_risk_flags(self, text: str) -> Dict:
        """Extract risk indicators using pattern matching"""
        text_lower = text.lower()
        risk_flags = {}
        
        for risk_type, patterns in self.risk_patterns.items():
            matches = []
            for pattern in patterns:
                matches.extend(re.findall(pattern, text_lower))
            
            risk_flags[risk_type] = {
                'detected': len(matches) > 0,
                'count': len(matches),
                'matches': list(set(matches))  # unique matches
            }
        
        return risk_flags
    
    def calculate_urgency_score(self, text: str, sentiment: Dict, risk_flags: Dict) -> float:
        """Calculate composite urgency score (0-1 scale)"""
        urgency_score = 0.0
        
        # Base urgency from sentiment (negative sentiment = higher urgency)
        if sentiment['sentiment'] == 'negative':
            urgency_score += 0.3 * sentiment['confidence']
        
        # Risk flag contributions
        risk_weights = {
            'crisis_indicators': 0.4,
            'substance_use': 0.2,
            'housing_crisis': 0.3,
            'mental_health': 0.25,
            'family_separation': 0.15
        }
        
        for risk_type, weight in risk_weights.items():
            if risk_flags[risk_type]['detected']:
                # Scale by number of matches (max 3)
                match_factor = min(risk_flags[risk_type]['count'] / 3, 1.0)
                urgency_score += weight * match_factor
        
        return min(urgency_score, 1.0)  # Cap at 1.0
    
    def process_case_notes(self, csv_path: str, output_path: str = None) -> pd.DataFrame:
        """
        Process case notes from R-exported CSV
        Returns enhanced dataframe with NLP analysis
        """
        # Load data from R
        df = pd.read_csv(csv_path)
        
        # Initialize result columns
        df['sentiment_analysis'] = None
        df['risk_flags'] = None
        df['urgency_score'] = None
        
        # Process each case note
        for idx, row in df.iterrows():
            text = row['case_note']
            
            # Sentiment analysis
            sentiment = self.analyze_sentiment(text)
            
            # Risk flag extraction
            risk_flags = self.extract_risk_flags(text)
            
            # Urgency scoring
            urgency = self.calculate_urgency_score(text, sentiment, risk_flags)
            
            # Store results
            df.at[idx, 'sentiment_analysis'] = json.dumps(sentiment)
            df.at[idx, 'risk_flags'] = json.dumps(risk_flags)
            df.at[idx, 'urgency_score'] = urgency
        
        # Save enhanced dataset
        if output_path:
            df.to_csv(output_path, index=False)
            print(f"Enhanced case notes saved to: {output_path}")
        
        return df
    
    def generate_summary_report(self, df: pd.DataFrame) -> Dict:
        """Generate summary report of NLP analysis results"""
        # Parse JSON columns for analysis
        df_analysis = df.copy()
        df_analysis['sentiment'] = df_analysis['sentiment_analysis'].apply(
            lambda x: json.loads(x)['sentiment'] if pd.notna(x) else 'unknown'
        )
        
        # Sentiment distribution
        sentiment_dist = df_analysis['sentiment'].value_counts().to_dict()
        
        # Risk flag prevalence
        risk_prevalence = {}
        for risk_type in self.risk_patterns.keys():
            risk_count = sum([
                json.loads(row)['detected'] 
                for row in df_analysis['risk_flags'] 
                if pd.notna(row)
            ])
            risk_prevalence[risk_type] = risk_count / len(df_analysis)
        
        # Urgency score statistics
        urgency_stats = {
            'mean': df_analysis['urgency_score'].mean(),
            'median': df_analysis['urgency_score'].median(),
            'high_urgency_count': sum(df_analysis['urgency_score'] > 0.7),
            'high_urgency_rate': sum(df_analysis['urgency_score'] > 0.7) / len(df_analysis)
        }
        
        return {
            'total_cases': len(df_analysis),
            'sentiment_distribution': sentiment_dist,
            'risk_flag_prevalence': risk_prevalence,
            'urgency_statistics': urgency_stats
        }

def main():
    """Main processing function for integration with R workflow"""
    processor = CaseNoteNLPProcessor()
    
    # Process case notes (path from R export)
    input_path = "../temp/notes_for_nlp.csv"
    output_path = "../temp/notes_nlp_enhanced.csv"
    
    try:
        enhanced_df = processor.process_case_notes(input_path, output_path)
        summary = processor.generate_summary_report(enhanced_df)
        
        # Save summary report
        with open("../output/nlp_summary_report.json", "w") as f:
            json.dump(summary, f, indent=2)
        
        print("NLP processing completed successfully!")
        print(f"Processed {len(enhanced_df)} case notes")
        print(f"Summary report saved to: ../output/nlp_summary_report.json")
        
    except FileNotFoundError:
        print(f"Input file not found: {input_path}")
        print("Run R analysis first to generate notes_for_nlp.csv")
    except Exception as e:
        print(f"Error during NLP processing: {e}")

if __name__ == "__main__":
    main()
